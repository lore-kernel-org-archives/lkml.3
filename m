Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab3BHAVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:21:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60253 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3BHAVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:21:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 0/2] ACPI / scan: Remove useless #ifndef and simplify container driver
Date: Fri, 08 Feb 2013 01:24:19 +0100
Message-ID: <1468930.acVuhKfKYv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5090866.2BHgpRnuEZ@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <3164478.OcagzIMET0@vostro.rjw.lan> <5090866.2BHgpRnuEZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 12:47:31 AM Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The only useful thing that the ACPI container driver does is to
> install system notify handlers for all container and module device
> objects it finds in the namespace.  The driver structure,
> acpi_container_driver, and the data structures created by its
> .add() callback are in fact not used by the driver, so remove
> them entirely.
> 
> It also makes a little sense to build that driver as a module,
> so make it non-modular and add its initialization to the
> namespace scanning code.
> 
> In addition to that, make the namespace walk callback used for
> installing the notify handlers more straightforward.

As pointed out by Toshi Kani, the above changes would make acpi_eject_store()
fail for containers and it is the only way to eject them currently, so patch
[2/2] is an improved version of this (with Toshi's changes folded in).

Patch [1/2] is just a cleanup removing a useless #ifndef from acpi_eject_store().

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
