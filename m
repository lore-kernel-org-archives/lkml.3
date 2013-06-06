Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3FFBda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:33:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755990Ab3FFBd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:33:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,810,1363104000"; 
   d="scan'208";a="7472787"
From: liguang <lig.fnst@cn.fujitsu.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 0/3] add cpu physically hotplug driver
Date: Thu, 6 Jun 2013 09:32:13 +0800
Message-Id: <1370482336-636-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 09:31:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 09:31:44,
	Serialize complete at 2013/06/06 09:31:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set try to support physically hot-plug/unplug
a cpu automatically, that is:
if you offline a cpu, it will automatically actually remove
a cpu, and if you hot-plug a cpu, then it will online this
cpu automatically.
so, offline is just like eject, but eject attribute seems not
available since recent kernel(can't figure out when), with
this driver, if allowed, it will trigger a eject cpu process.
and for automatically online, it was said there are objections,
don't know the reason, so, send this patch-set boldly.

of course, this approach is for QEMU 's hotplug cpu emulation 
only, but not limited, if someone like to explore ec space to
implment cpu hot-plug/unplug for real platform please
feel free to continue.

Li Guang (3)
	 drivers/platform/x86: add cpu physically hotplug driver
	 ec: add ec space notifier
	 cpu_physic_hotplug: register handler for ec space notifier

drivers/acpi/ec.c                         | 32 ++++++++++++++++++++++++++++++++
drivers/platform/x86/Kconfig              |  8 ++++
drivers/platform/x86/Makefile             |  1 +
drivers/platform/x86/cpu_physic_hotplug.c | 87 +++++++++++++++++++++++++++++
include/linux/acpi.h                      |  2 ++
5 files changed, 128 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/x86/cpu_physic_hotplug.c

