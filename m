Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbbAONBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:01:45 -0500
Received: from mga14.intel.com ([192.55.52.115]:11640 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbbAONBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:01:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,403,1418112000"; 
   d="scan'208";a="637718270"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [Bugfix v4 0/2] Fix xen IRQ allocation failure caused by commit b81975eade8c
Date: Thu, 15 Jan 2015 21:04:34 +0800
Message-Id: <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With more knowledge of Xen interrupt manangement subsytem, I realized
previous three versions to fix https://lkml.org/lkml/2014/12/19/178 are
just plainly wrong. Those patches try to fix the issue by creating
irqdomain for IOAPICs for PV domains, which effectively let native
IOAPIC driver and Xen PV interrupt management subsystem to manage
IOAPIC irqs concurrently, sounds unpredictable.

Sorry for those wrong fixes. The good news is that the new fix does
make code simpler and easier to maintain.

I have tested the patchset on Intel platform with bare metal and Dom0
kernels.

Hi Sander,
	Could you please help to test it again?

Regards!
Gerry

Jiang Liu (2):
  xen/pci: Kill function xen_setup_acpi_sci()
  xen/pci: Simplify x86/pci/xen.c by killing gsi_override related code

 arch/x86/kernel/acpi/boot.c |   26 ++++++++---------
 arch/x86/pci/xen.c          |   68 ++++---------------------------------------
 2 files changed, 19 insertions(+), 75 deletions(-)

-- 
1.7.10.4

