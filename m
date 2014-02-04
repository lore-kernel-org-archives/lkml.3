Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaBDXp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:45:56 -0500
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:49454 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933230AbaBDXpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:45:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:967:968:973:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2194:2198:2199:2200:2393:2525:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3770:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4560:4605:5007:6119:7652:7901:7903:9025:9040:9108:9388:10004:10049:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12663:12740:13095:13141:13
X-HE-Tag: ball34_502d0b2038744
X-Filterd-Recvd-Size: 3980
Message-ID: <1391557549.2538.39.camel@joe-AO722>
Subject: Re: [PATCH v7 2/3] trivial: PM / Hibernate: clean up checkpatch in
 hibernate.c
From: Joe Perches <joe@perches.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 04 Feb 2014 15:45:49 -0800
In-Reply-To: <20140204220534.28287.21049@capellas-linux>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org>
	 <1391546631-7715-3-git-send-email-sebastian.capella@linaro.org>
	 <1391548862.2538.34.camel@joe-AO722>
	 <20140204220534.28287.21049@capellas-linux>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 14:05 -0800, Sebastian Capella wrote:
> Quoting Joe Perches (2014-02-04 13:21:02)
> > On Tue, 2014-02-04 at 12:43 -0800, Sebastian Capella wrote:
> > > Checkpatch reports several warnings in hibernate.c
> > > printk use removed, long lines wrapped, whitespace cleanup,
> > > extend short msleeps, while loops on two lines.
> > []
> > > diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> > []
> > > @@ -765,7 +762,7 @@ static int software_resume(void)
> > >       if (isdigit(resume_file[0]) && resume_wait) {
> > >               int partno;
> > >               while (!get_gendisk(swsusp_resume_device, &partno))
> > > -                     msleep(10);
> > > +                     msleep(20);
> > 
> > What good is changing this from 10 to 20?
> > 
> > > @@ -776,8 +773,9 @@ static int software_resume(void)
> > >               wait_for_device_probe();
> > >  
> > >               if (resume_wait) {
> > > -                     while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
> > > -                             msleep(10);
> > > +                     while ((swsusp_resume_device =
> > > +                                     name_to_dev_t(resume_file)) == 0)
> > > +                             msleep(20);
> > 
> > here too.
> 
> Thanks Joe!
> 
> I'm happy to make whatever change is best.  I just ran into one
> checkpatch warning around a printk I indented and figured I'd try to get
> them all if I could.

Shutting up checkpatch for the sake of shutting of
checkpatch is sometimes not the right thing to do.

> The delays in question didn't appear timing critical as both are looping
> waiting for device discovery to complete.  They're only enabled when using
> the resumewait command line parameter.

Any time it happens faster doesn't hurt and
can therefore could resume faster no?

> Is this an incorrect checkpatch warning?  The message from checkpatch
> implies using msleep for smaller values can be misleading.

That's true, but it doesn't mean it's required
to change the code.

>   - Why not msleep for (1ms - 20ms)?                               
>     Explained originally here:                               
>       http://lkml.org/lkml/2007/8/3/250                
>     msleep(1~20) may not do what the caller intends, and     
>     will often sleep longer (~20 ms actual sleep for any     
>     value given in the 1~20ms range). In many cases this     
>     is not the desired behavior. 
> 
> When I look at kernel/timers.c in my current kernel, I see msleep is
> using msecs_to_jiffies + 1, and on my current platform this appears to
> be ~20msec as the jiffies are 10ms.

And on platforms where HZ is 1000, it's
still slightly faster.

I'd just leave it alone.

