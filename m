Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaCaTvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:51:54 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51371 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaCaTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:51:53 -0400
Date: Mon, 31 Mar 2014 23:51:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com
Subject: Re: [rfc 1/2] timerfd: Implement show_fdinfo method
Message-ID: <20140331195150.GO4872@moon>
References: <20140331175407.400476950@openvz.org>
 <20140331175957.509391054@openvz.org>
 <alpine.DEB.2.02.1403312134570.14882@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403312134570.14882@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:43:13PM +0200, Thomas Gleixner wrote:
> > Index: linux-2.6.git/fs/timerfd.c
> > ===================================================================
> > --- linux-2.6.git.orig/fs/timerfd.c
> > +++ linux-2.6.git/fs/timerfd.c
> > @@ -284,11 +284,20 @@ static ssize_t timerfd_read(struct file
> >  	return res;
> >  }
> >  
> > +static int timerfd_show(struct seq_file *m, struct file *file)
> > +{
> > +	struct timerfd_ctx *ctx = file->private_data;
> > +
> > +	return seq_printf(m, "clockid: %d ticks: %llu\n",
> > +			  ctx->clockid, (unsigned long long)ctx->ticks);
> > +}
> 
> And what gives you the flags which were used in timerfd_settime()
> along with the remaining time to expiry and the interval?

Ouch, indeed, I need to export them as well. Thanks a lot!
