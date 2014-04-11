Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaDKKKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:10:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaDKKKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:10:13 -0400
Message-ID: <1397200199.5290.3.camel@linux-fkkt.site>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
From: Oliver Neukum <oneukum@suse.de>
To: Xiao Jin <jin.xiao@intel.com>
Cc: jhovold@gmail.com, gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
In-Reply-To: <5347206E.5050701@intel.com>
References: <53436770.9090008@intel.com> <53455FC6.7080009@intel.com>
	 <1397116923.4802.10.camel@linux-fkkt.site> <5347206E.5050701@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Apr 2014 09:09:59 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 06:51 +0800, Xiao Jin wrote:
> Hi, Oliver,
> 
> On 04/10/2014 04:02 PM, Oliver Neukum wrote:
> > On Wed, 2014-04-09 at 22:57 +0800, Xiao Jin wrote:
> >> Thanks all for the review. We meet with the problems when developing
> >> product. I would like to explain my understanding.
> >>
> >> On 04/08/2014 11:05 AM, Xiao Jin wrote:
> >>>
> >>> We find two problems on acm tty write delayed mechanism.
> >>> (1) When acm resume, the delayed wb will be started. But now
> >>> only one write can be saved during acm suspend. More acm write
> >>> may be abandoned.
> >>
> >> The scenario usually happened when user space write series AT after acm
> >> suspend. If acm accept the first AT, what's the reason for acm to refuse
> >> the second AT? If write return 0, user space will try repeatedly until
> >> resume. It looks simpler that acm accept all the data and sent out urb
> >> when resume.
> >
> > No. We cannot accept an arbitrary amount of data. It would let any
> > user OOM the system. There will have to be an arbitrary limit.
> > The simplest limit is 1 urb. And that is because we said that we
> > are ready to accept data.
> >
> 
> We apply cdc-acm for modem AT data. I can find other usb modem driver 
> usb_wwan_write use list to accept more data when suspend, maybe usbnet
> is the same. Do you have any more reason for me to understand why 
> cdc-acm accept only one?

User space must be ready to deal with a device that cannot
accept any more data. There is simply no additional benefit
in more caching.

> We see tty write and close concurrently, we have debug log to show that 
> acm_tty_write and acm_resume is called after acm_port_shutdown, I don't 
> understand "resuming the device in shutdown() should do the job".

There we have a problem. In fact it looks like a bug in the tty layer.
Could you post the logs?

	Regards
		Oliver


