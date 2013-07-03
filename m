Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab3GCXTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:19:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57740 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933710Ab3GCXSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:18:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 0/4] ACPI / dock: One fix and more cleanups
Date: Thu, 04 Jul 2013 01:23:51 +0200
Message-ID: <2759309.GsYqNLU1ac@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1515394.L46AJCfCTt@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan> <1515394.L46AJCfCTt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As I said before, the ACPI dock driver seems to be in an endless need for
cleanups and fixes.  This time I found one oddity (patch [1/4]) a couple of
nitpicks ([2/4] and [4/4]) and a notifier chain that can be dropped (unless
I'm overlooking a reason why those things have to be done atomically - [3/4]).

[1/4] Actually define acpi_dock_init() as void (-stable material).
[2/4] Do not check if ACPI dock is a module (it can't be).
[3/4] Drop ACPI dock notifier chain (and modify acpiphp to use something
      different for fixups).
[4/4] Drop unnecessary local variable from dock_add().

All on top of the bleeding-edge branch of the linux-pm.git tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
