Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaIPAvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbaIPAvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:51:31 -0400
Date: Tue, 16 Sep 2014 08:50:03 +0800
From: Amos Kong <akong@redhat.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        amit.shah@redhat.com, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, m@bues.ch, herbert@gondor.apana.org.au,
        mpm@selenic.com
Subject: Re: [PATCH 2/2] virtio-rng: fix stuck in catting hwrng attributes
Message-ID: <20140916005003.GC5671@zen>
References: <1410340027-15373-1-git-send-email-akong@redhat.com>
 <1410340027-15373-3-git-send-email-akong@redhat.com>
 <8738byie04.fsf@rustcorp.com.au>
 <20140913171258.GB12276@zen.redhat.com>
 <20140914011208.GA1032@zen.redhat.com>
 <20140914022553.GC1032@zen.redhat.com>
 <20140915164846.GA29862@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140915164846.GA29862@potion.brq.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC linux-kernel

Original thread: http://comments.gmane.org/gmane.linux.kernel.virtualization/22775

On Mon, Sep 15, 2014 at 06:48:46PM +0200, Radim Krčmář wrote:
> 2014-09-14 10:25+0800, Amos Kong:
> > On Sun, Sep 14, 2014 at 09:12:08AM +0800, Amos Kong wrote:
> > 
> > ...
> > > > > > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > > > > > index c591d7e..b5d1b6f 100644
> > > > > > --- a/drivers/char/hw_random/core.c
> > > > > > +++ b/drivers/char/hw_random/core.c
> > > > > > @@ -195,8 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
> > > > > >  
> > > > > >  		mutex_unlock(&rng_mutex);
> > > > > >  
> > > > > > -		if (need_resched())
> > > > > > -			schedule_timeout_interruptible(1);
> > > > > > +		schedule_timeout_interruptible(10);
> 
> If cond_resched() does not work, it is a bug elsewehere.

Thanks for your reply, Jason also told me the TIF_NEED_RESCHED should
be set in this case, then need_resched() returns true.

I will investigate the issue and reply you later.
 
> > Problem only occurred in non-smp guest, we can improve it to:
> > 
> >                         if(!is_smp())
> >                                 schedule_timeout_interruptible(10);
> > 
> > is_smp() is only available for arm arch, we need a general one.
> 
> (It is num_online_cpus() > 1.)

-- 
			Amos.
