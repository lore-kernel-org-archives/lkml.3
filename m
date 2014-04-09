Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbaDIRxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:53:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:42146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323AbaDIRxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:53:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="scan'208";a="510288424"
Date: Wed, 9 Apr 2014 10:43:40 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Xiao Jin <jin.xiao@intel.com>
Cc: oneukum@suse.de, jhovold@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, yanmin.zhang@intel.com
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140409174340.GB23274@psi-dev26.jf.intel.com>
References: <53436770.9090008@intel.com>
 <53455FC6.7080009@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53455FC6.7080009@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:57:10PM +0800, Xiao Jin wrote:
> Thanks all for the review. We meet with the problems when developing
> product. I would like to explain my understanding.
> 
> On 04/08/2014 11:05 AM, Xiao Jin wrote:
> >
> >We find two problems on acm tty write delayed mechanism.
> >(1) When acm resume, the delayed wb will be started. But now
> >only one write can be saved during acm suspend. More acm write
> >may be abandoned.
> 
> The scenario usually happened when user space write series AT after acm
> suspend. If acm accept the first AT, what's the reason for acm to refuse the
> second AT? If write return 0, user space will try repeatedly until resume.
> It looks simpler that acm accept all the data and sent out urb when resume.

That was my understanding too. The delayed mechanism is not being
implemented by this patch, just improved.

Br, David

> 
> >(2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> >close. If acm resume callback run after ASYNCB_INITIALIZED flag
> >cleared, there will have no chance for delayed write to start.
> >That lead to acm_wb.use can't be cleared. If user space open
> >acm tty again and try to setd, tty will be blocked in
> >tty_wait_until_sent for ever.
> >
> 
> We see tty write and close concurrently after acm suspend in this case. It
> looks no method to avoid it from tty layer. acm_tty_write and acm_resume
> call after acm_port_shutdown. It looks any action in acm_port_shutdown can't
> solve the problem. As acm has accepted the user space data, we can only find
> a way to send out urb. I feel anyway to discard the data looks like a lie to
> user space.
> 
> In my understanding acm should accept data as much as possible, and send out
> urb as soon as possible. What do you think of?
> 
> Br, Jin
