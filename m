Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3BVUx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:53:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41675 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322Ab3BVUxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:53:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Huang Ying <ying.huang@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG bisected]: apei_hest_parse explosion
Date: Fri, 22 Feb 2013 22:00:35 +0100
Message-ID: <1744414.jv1oTA61l1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.02.1302221539110.22263@ionos>
References: <alpine.LFD.2.02.1302220002040.22263@ionos> <5350252.GArARx6b7p@vostro.rjw.lan> <alpine.LFD.2.02.1302221539110.22263@ionos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 03:39:44 PM Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / APEI: Fix crash in apei_hest_parse() for acpi=off
> > 
> > After commit 92ef2a2 (ACPI: Change the ordering of PCI root bridge
> > driver registrarion), acpi_hest_init() is never called for acpi=off
> > (acpi_disabled), so hest_disable is not set, but hest_tab is NULL,
> > which causes apei_hest_parse() to crash when it is called from
> > aer_acpi_firmware_first().
> > 
> > Fix that by making apei_hest_parse() check if hest_tab is not NULL
> > in addition to checking hest_disable.  Also remove the now useless
> > acpi_disabled check from apei_hest_parse().
> > 
> > Reported-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Tested-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

