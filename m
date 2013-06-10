Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3FJLiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:38:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33139 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3FJLiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:38:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Len Brown <lenb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH RFC v2 0/3] add cpu physically hotplug driver
Date: Mon, 10 Jun 2013 13:47:17 +0200
Message-ID: <1875411.erfv3Z7LVk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370837061.21655.54.camel@liguang.fnst.cn.fujitsu.com>
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com> <51B54D51.2070505@jp.fujitsu.com> <1370837061.21655.54.camel@liguang.fnst.cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 10, 2013 12:04:21 PM li guang wrote:
> 在 2013-06-10一的 12:51 +0900，Yasuaki Ishimatsu写道：
> > 2013/06/10 9:36, li guang wrote:
> > > Hi, Rafael
> > >
> > > 在 2013-06-06四的 13:00 +0200，Rafael J. Wysocki写道：
> > >> On Thursday, June 06, 2013 09:40:32 AM liguang wrote:
> > >>> This patch-set try to support physically hot-plug/unplug
> > >>> a cpu automatically, that is:
> > >>> if you offline a cpu, it will automatically actually remove
> > >>> a cpu, and if you hot-plug a cpu, then it will online this
> > >>> cpu automatically.
> > >>
> > >> No and no.
> > >
> > > Hmm... are you saying cpu online/offline designed to distinguish
> > > with real cpu plug/unplug?
> > > but, what the actual usage of online/offline?
> > > forgive my foolish.
> > >
> > >>
> > >> Why do you need this?
> > >>
> > >
> > > e.g. for QEMU case, if hot-plug a cpu,
> > 
> > > we have to online a cpu manually if there's
> > > no user space support like udev to do it automatically.
> > 
> > I could not understand why you do not use udev.
> > Please explain in detail.
> 
> I did not say I can't use udev now,
> just for in case someone can't.
> 
> > 
> > > and also, I think maybe online/offline should be naturally
> > > integrated with real plug/unplug process of CPU.
> > 
> > I could not understand this explanation too.
> > Why do we need it?
> > 
> 
> actually, I am asking if CPU online/offline have real purpose,
> you offline a CPU, then threads can't run on it,
> you online a CPU, then threads can run on it,
> so, the purpose here is just bouncing threads?
> obviously not, any profound historical reasons?

The purpose is to ensure that the CPU won't be used after the offline
and the online is simply complementary.

> I boldly think maybe online/offline should be integrated into
> real plug/unplug process of CPU.

Well, please look into the acpi-hotplug branch of the linux-pm.git tree for
patches that do just that.

Thanks,
Rafael


> 
> Thanks!
> 
> > >
> > >>
> > >>
> > >>> so, offline is just like eject, but eject attribute seems not
> > >>> available since recent kernel(can't figure out when), with
> > >>> this driver, if allowed, it will trigger a eject cpu process.
> > >>> and for automatically online, it was said there are objections,
> > >>> don't know the reason, so, send this patch-set boldly.
> > >>>
> > >>> of course, this approach is for QEMU 's hotplug cpu emulation
> > >>> only, but not limited, if someone like to explore ec space to
> > >>> implment cpu hot-plug/unplug for real platform please
> > >>> feel free to continue.
> > >>>
> > >>> Li Guang (3)
> > >>> 	 drivers/platform/x86: add cpu physically hotplug driver
> > >>> 	 ec: add ec space notifier
> > >>> 	 cpu_physic_hotplug: register handler for ec space notifier
> > >>>
> > >>> drivers/acpi/ec.c                         | 32 ++++++++++++++++++++++++++++++++
> > >>> drivers/platform/x86/Kconfig              |  8 ++++
> > >>> drivers/platform/x86/Makefile             |  1 +
> > >>> drivers/platform/x86/cpu_physic_hotplug.c | 90 +++++++++++++++++++++++++++++
> > >>> include/linux/acpi.h                      |  2 ++
> > >>> 5 files changed, 130 insertions(+), 3 deletions(-)
> > >>>   create mode 100644 drivers/platform/x86/cpu_physic_hotplug.c
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> > 
> > 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
