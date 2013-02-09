Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab3BIOZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:25:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36271 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760693Ab3BIOYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:24:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 0/2] ACPI / scan: Two fixes for device hot-removal
Date: Sat, 09 Feb 2013 15:26 +0100
Message-ID: <2074190.mMzUc3TOxk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1468930.acVuhKfKYv@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <5090866.2BHgpRnuEZ@vostro.rjw.lan> <1468930.acVuhKfKYv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches fix issues I've found revently in the ACPI device
hot-removal code.

Patch [1/2] makes acpi_bus_hot_remove_device() hold acpi_scan_lock around the
whole removal procedure to prevent potential race condition between
acpi_bus_scan() and a conflicting evaluation of _EJ0 from happening.

Patch [2/2] makes acpi_device_unregister() put devices (supporting that) into
D3cold to prevent potential problems with removing power from them without
preparation from happening and removes the totally wrong evaluation of _PS3
from acpi_bus_hot_remove_device().

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
