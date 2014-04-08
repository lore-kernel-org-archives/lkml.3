Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaDHKdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:33:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaDHKdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:33:33 -0400
Message-ID: <1396953211.25633.16.camel@linux-fkkt.site>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
From: Oliver Neukum <oneukum@suse.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Xiao Jin <jin.xiao@intel.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Date: Tue, 08 Apr 2014 12:33:31 +0200
In-Reply-To: <20140408073306.GB25779@localhost>
References: <53436770.9090008@intel.com> <20140408073306.GB25779@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-08 at 09:33 +0200, Johan Hovold wrote:
> On Tue, Apr 08, 2014 at 11:05:20AM +0800, Xiao Jin wrote:

> > (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> > close. If acm resume callback run after ASYNCB_INITIALIZED flag
> > cleared, there will have no chance for delayed write to start.
> > That lead to acm_wb.use can't be cleared. If user space open
> > acm tty again and try to setd, tty will be blocked in
> > tty_wait_until_sent for ever.
> >
> > This patch have two modification.
> > (1) use list_head to save the write acm_wb during acm suspend.
> > It can ensure no acm write abandoned.
> > (2) enable flush buffer callback when acm tty close. acm delayed
> > wb will start before acm port shutdown callback, it make sure
> > the delayed acm_wb.use to be cleared. The patch also clear
> > acm_wb.use and acm.transmitting when port shutdown.
> 
> This is not the right way to do this. See below.

If I see this correctly, then ASYNCB_INITIALIZED is cleared in
tty_port_close() we is called from acm_tty_close(). Thus it should
be enough to make sure that the device is resumed at the beginning
of acm_tty_close() and acm_resume() will do the job automatically.
What do you think?

	Regards
		Oliver


