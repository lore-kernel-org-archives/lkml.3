Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbbANPGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:06:55 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59207 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbANPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:06:53 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Wed, 14 Jan 2015 23:04:48 +0800
Message-Id: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1

updates from v6:
  - Rebased on top of 3.19-rc4, add Mack Salter's patch to use
    the early_ioremap after paging_init() for ACPI table mappings;

  - Two patches about converting apic_id to phys_id to make it arch
    agnostic were already merged into RC4 by Rafael.

  - Split patch "Parse FADT table to get PSCI flags for PSCI init"
    into two as Lorenzo's suggestion, also fix typo and lack of __init
    for psci_0_2_set_functions() which is spotted by Lorenzo.

  - Add Tested-by from Yijing Wang.

previous version is here:
v6: https://lkml.org/lkml/2015/1/4/40

1. Why we need ACPI on ARM64?

  - Grant already posted a blog about this, and stated clearly
    why we need ACPI on ARM64:

    http://www.secretlab.ca/archives/151


2. What we need to do before the arm64 ACPI core patches
   could be merged into the kernel?

  - Al Stone posted a TODO list and updates v2 for the
    progress we made:
    http://www.spinics.net/lists/arm-kernel/msg390069.html

  - so from the progress we can see that we already finished
    most of the items, and _OSI we got a plan to fix it, RFC
    patch is on the way.


This patch set was tested on FVP by Fuwei, and booted ok as expected.
(No functional change since last version)

Thanks
Hanjun

