Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3EJLD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:03:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42681 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab3EJLD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:03:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH -v8 01/11] CPU hotplug: Provide a generic helper to disable/enable CPU hotplug
Date: Fri, 10 May 2013 13:11:51 +0200
Message-ID: <1651579.orCh9JNVz6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130509150121.8c3ef60b2fc748ce542a1a52@linux-foundation.org>
References: <1367937595-32241-1-git-send-email-holt@sgi.com> <1367937595-32241-2-git-send-email-holt@sgi.com> <20130509150121.8c3ef60b2fc748ce542a1a52@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 09, 2013 03:01:21 PM Andrew Morton wrote:
> On Tue,  7 May 2013 09:39:45 -0500 Robin Holt <holt@sgi.com> wrote:
> 
> > From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> > 
> > There are instances in the kernel where we would like to disable
> > CPU hotplug (from sysfs) during some important operation. Today
> > the freezer code depends on this and the code to do it was kinda
> > tailor-made for that.
> > 
> > Restructure the code and make it generic enough to be useful for
> > other usecases too.
> > 
> > ...
> >
> > --- a/include/linux/cpu.h
> > +++ b/include/linux/cpu.h
> > @@ -141,6 +141,8 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
> >  }
> >  #endif
> >  
> > +extern void cpu_hotplug_disable(void);
> > +extern void cpu_hotplug_enable(void);
> >  int cpu_up(unsigned int cpu);
> >  void notify_cpu_starting(unsigned int cpu);
> >  extern void cpu_maps_update_begin(void);
> > @@ -148,6 +150,7 @@ extern void cpu_maps_update_done(void);
> >  
> >  #else	/* CONFIG_SMP */
> >  
> > +#define cpu_hotplug_disable()	do { } while (0)
> >  #define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> >  
> 
> Breaks alpha allmodconfig because cpu_hotplug_disable() is absent from
> vmlinux.
> 
> cpu_hotplug_disable() doesn't get compiled unless we've defined
> CONFIG_PM_SLEEP_SMP.  I cannot begin to imagine what the logic is
> behind that!

I suppose it was only used by suspend/hibernate code paths when this was
introduced.

Thanks,
Rafael

