Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab3BVOjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:39:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:58007 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3BVOjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:39:52 -0500
Date: Fri, 22 Feb 2013 15:39:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Huang Ying <ying.huang@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG bisected]: apei_hest_parse explosion
In-Reply-To: <5350252.GArARx6b7p@vostro.rjw.lan>
Message-ID: <alpine.LFD.2.02.1302221539110.22263@ionos>
References: <alpine.LFD.2.02.1302220002040.22263@ionos> <4867361.uTndA5QxsU@vostro.rjw.lan> <alpine.LFD.2.02.1302220903000.22263@ionos> <5350252.GArARx6b7p@vostro.rjw.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / APEI: Fix crash in apei_hest_parse() for acpi=off
> 
> After commit 92ef2a2 (ACPI: Change the ordering of PCI root bridge
> driver registrarion), acpi_hest_init() is never called for acpi=off
> (acpi_disabled), so hest_disable is not set, but hest_tab is NULL,
> which causes apei_hest_parse() to crash when it is called from
> aer_acpi_firmware_first().
> 
> Fix that by making apei_hest_parse() check if hest_tab is not NULL
> in addition to checking hest_disable.  Also remove the now useless
> acpi_disabled check from apei_hest_parse().
> 
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Tested-by: Thomas Gleixner <tglx@linutronix.de>
