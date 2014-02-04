Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaBDXpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:45:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64626 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933236AbaBDXpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:45:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH v7 2/3] trivial: PM / Hibernate: clean up checkpatch in hibernate.c
Date: Wed, 05 Feb 2014 00:59:59 +0100
Message-ID: <4317708.1544moHa91@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140204223733.30015.23993@capellas-linux>
References: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org> <9487103.2jnJmCRm9n@vostro.rjw.lan> <20140204223733.30015.23993@capellas-linux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 04, 2014 02:37:33 PM Sebastian Capella wrote:
> Quoting Rafael J. Wysocki (2014-02-04 13:36:29)
> > Well, this isn't a trivial patch.
> 
> I'll remove the trivial, thanks!
> 
> Quoting Rafael J. Wysocki (2014-02-04 13:36:29)
> > On Tuesday, February 04, 2014 12:43:50 PM Sebastian Capella wrote:
> > > +     while (1)
> > > +             ;
> > Please remove this change from the patch.  I don't care about checkpatch
> > complaining here.
> > > +     while (1)
> > > +             ;
> > Same here.
> 
> Will do, thanks!
> 
> > > @@ -765,7 +762,7 @@ static int software_resume(void)
> > >       if (isdigit(resume_file[0]) && resume_wait) {
> > >               int partno;
> > >               while (!get_gendisk(swsusp_resume_device, &partno))
> > > -                     msleep(10);
> > > +                     msleep(20);
> > 
> > That's the reason why it is not trivial.
> > 
> > First, the change being made doesn't belong in this patch.
> 
> Thanks I'll separate it if it remains.
> 
> > Second, what's the problem with the original value?
> 
> The warning from checkpatch implies that it's misleading to
> msleep < 20ms since msleep is using msec_to_jiffies + 1 for
> the duration.  In any case, this is polling for devices discovery to
> complete.  It is used when resumewait is specified on the command
> line telling hibernate to wait for the resume device to appear.

What checkpatch is saying is about *new* code, not the existing one.

You need to have a *reason* to change the way the existing code works
and the above explanation doesn't sound like a good one to me in this
particular case.

> > > -static ssize_t image_size_show(struct kobject *kobj, struct kobj_attribute *attr,
> > > +static ssize_t image_size_show(struct kobject *kobj,
> > > +                            struct kobj_attribute *attr,
> > Why can't you leave the code as is here?
> > > -static ssize_t image_size_store(struct kobject *kobj, struct kobj_attribute *attr,
> > > +static ssize_t image_size_store(struct kobject *kobj,
> > > +                             struct kobj_attribute *attr,
> > And here?
> 
> Purely long line cleanup. (>80 colunms)

Please don't do any >80 columns cleanups in any patches you want me to apply.
Seriously.  This is irritating and unuseful.

And if you don't want checkpatch to complain about that, please send a patch
to modify checkpatch accordingly.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
