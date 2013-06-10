Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3FJEMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:12:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3FJEMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:12:48 -0400
X-IronPort-AV: E=Sophos;i="4.87,834,1363104000"; 
   d="scan'208";a="7511766"
Subject: Re: [PATCH RFC v2 0/3] add cpu physically hotplug driver
From: li guang <lig.fnst@cn.fujitsu.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>
In-Reply-To: <51B54D51.2070505@jp.fujitsu.com>
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <5449620.11SBDUltzF@vostro.rjw.lan>
	 <1370824567.21655.10.camel@liguang.fnst.cn.fujitsu.com>
	 <51B54D51.2070505@jp.fujitsu.com>
Date: Mon, 10 Jun 2013 12:04:21 +0800
Message-ID: <1370837061.21655.54.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 12:04:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 12:04:09,
	Serialize complete at 2013/06/10 12:04:09
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-06-10一的 12:51 +0900，Yasuaki Ishimatsu写道：
> 2013/06/10 9:36, li guang wrote:
> > Hi, Rafael
> >
> > 在 2013-06-06四的 13:00 +0200，Rafael J. Wysocki写道：
> >> On Thursday, June 06, 2013 09:40:32 AM liguang wrote:
> >>> This patch-set try to support physically hot-plug/unplug
> >>> a cpu automatically, that is:
> >>> if you offline a cpu, it will automatically actually remove
> >>> a cpu, and if you hot-plug a cpu, then it will online this
> >>> cpu automatically.
> >>
> >> No and no.
> >
> > Hmm... are you saying cpu online/offline designed to distinguish
> > with real cpu plug/unplug?
> > but, what the actual usage of online/offline?
> > forgive my foolish.
> >
> >>
> >> Why do you need this?
> >>
> >
> > e.g. for QEMU case, if hot-plug a cpu,
> 
> > we have to online a cpu manually if there's
> > no user space support like udev to do it automatically.
> 
> I could not understand why you do not use udev.
> Please explain in detail.

I did not say I can't use udev now,
just for in case someone can't.

> 
> > and also, I think maybe online/offline should be naturally
> > integrated with real plug/unplug process of CPU.
> 
> I could not understand this explanation too.
> Why do we need it?
> 

actually, I am asking if CPU online/offline have real purpose,
you offline a CPU, then threads can't run on it,
you online a CPU, then threads can run on it,
so, the purpose here is just bouncing threads?
obviously not, any profound historical reasons?

I boldly think maybe online/offline should be integrated into
real plug/unplug process of CPU.

Thanks!

> >
> >>
> >>
> >>> so, offline is just like eject, but eject attribute seems not
> >>> available since recent kernel(can't figure out when), with
> >>> this driver, if allowed, it will trigger a eject cpu process.
> >>> and for automatically online, it was said there are objections,
> >>> don't know the reason, so, send this patch-set boldly.
> >>>
> >>> of course, this approach is for QEMU 's hotplug cpu emulation
> >>> only, but not limited, if someone like to explore ec space to
> >>> implment cpu hot-plug/unplug for real platform please
> >>> feel free to continue.
> >>>
> >>> Li Guang (3)
> >>> 	 drivers/platform/x86: add cpu physically hotplug driver
> >>> 	 ec: add ec space notifier
> >>> 	 cpu_physic_hotplug: register handler for ec space notifier
> >>>
> >>> drivers/acpi/ec.c                         | 32 ++++++++++++++++++++++++++++++++
> >>> drivers/platform/x86/Kconfig              |  8 ++++
> >>> drivers/platform/x86/Makefile             |  1 +
> >>> drivers/platform/x86/cpu_physic_hotplug.c | 90 +++++++++++++++++++++++++++++
> >>> include/linux/acpi.h                      |  2 ++
> >>> 5 files changed, 130 insertions(+), 3 deletions(-)
> >>>   create mode 100644 drivers/platform/x86/cpu_physic_hotplug.c
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 


