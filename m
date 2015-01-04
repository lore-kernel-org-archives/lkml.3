Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbbADKzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 05:55:36 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33361 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbADKzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 05:55:33 -0500
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
        suravee.suthikulpanit@amd.com, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v6 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
Date: Sun,  4 Jan 2015 18:55:01 +0800
Message-Id: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the sixth version of ACPI core patches for ARM64 based on ACPI
5.1.

updates from v5:
  - fix the NULL pointer reference in cpu_get_ops() if PSCI is absent
    and NULL will passed, which found by Suravee when he was testing
    those patches on Seattle platform. I added his Tested-by for all
    those ACPI patches.

  - Rebased on 3.19-rc2 which ACPI table related patches already merged
    into 3.19 by Rafael, and remove the first patch in v5 which is not needed
    any more.

  - Add two cleanup patches to convert ACPI ID to physical ID to make the
    ACPI core looks more ARCH agnostic, those two patches were expected going
    into 3.19 but conflicted with IOAPIC hotplug patches so Rafael left them
    for 3.20.

  - updates to the doc about ACPI on ARM to address comments from Catalin,
    Timur, Ashwin. continue discussion will bw needed about this doc.

  - we did lots of work as Al pointed out in the "[RFC] ACPI on arm64 TODO List"
    thread [1], and we already make FWTS running on ARM64, thanks FuWei for doing
    that. Here is the test results for linaro leg kernel release test results:

Test report for leg-20141215.0 (Revision: d37eefeb160cc9cc1db997031793723e317be7b7)

This test Image comes from  https://ci.linaro.org/job/linux-leg-fuwei
The CI job Link: https://ci.linaro.org/job/linux-leg-fuwei/37/

Notes : All the tests ran on FVP base model in LAVA server : http://validation.linaro.org/

The startup.nsh boot test Link :https://validation.linaro.org/scheduler/job/222779

The ACPI test Link : https://validation.linaro.org/scheduler/job/222781
    The results.log file Link : https://validation.linaro.org/dashboard/attachment/1267957/view

The grub-install test Link : https://validation.linaro.org/scheduler/job/222780

and here is the *summary*:

summary        -SUM:77 passed, 6 failed, 2 warnings, 5 aborted, 186 skipped, 8 info only.
summary        -NLN:
summary        -SUM:Test Failure Summary
summary        -SEP:===========================================================================================
summary        -NLN:
summary        -SUM:Critical failures: NONE
summary        -NLN:
summary        -SUM:High failures: 2
summary        -SUM: uefirttime: Failed to get wakeup time with UEFI runtime service.
summary        -SUM: uefirttime: Failed to set wakeup time with UEFI runtime service.
summary        -NLN:
summary        -SUM:Medium failures: 5
summary        -SUM: wakealarm: Could not find an RTC with an alarm ioctl() interface.
summary        -SUM: method: \_SB_.COM0._CID returned a string 'PL011' but it was not a valid PNP ID or a valid ACPI ID.
summary        -SUM: method: Object _PRS did not exist.
summary        -SUM: method: Object _PTS did not exist.
summary        -SUM: method: Object _WAK did not exist.
summary        -NLN:
summary        -SUM:Low failures: NONE
summary        -NLN:
summary        -SUM:Other failures: NONE
summary        -NLN:
summary        -SUM:Test           |Pass |Fail |Abort|Warn |Skip |Info |
summary        -SUM:---------------+-----+-----+-----+-----+-----+-----+
summary        -SUM:acpidump       |     |     |     |     |     |    1|
summary        -SUM:acpiinfo       |     |     |     |     |     |    3|
summary        -SUM:acpitables     |   11|     |     |    1|     |     |
summary        -SUM:aspm           |     |     |     |     |    1|     |
summary        -SUM:checksum       |    8|     |     |     |     |     |
summary        -SUM:cpufreq        |     |     |     |    1|     |     |
summary        -SUM:crsdump        |     |     |     |     |     |     |
summary        -SUM:gpedump        |     |     |     |     |     |     |
summary        -SUM:hda_audio      |     |     |     |     |    1|     |
summary        -SUM:klog           |    1|     |     |     |     |     |
summary        -SUM:maxreadreq     |     |     |     |     |     |     |
summary        -SUM:method         |   29|    4|     |     |  173|     |
summary        -SUM:oops           |    2|     |     |     |     |     |
summary        -SUM:plddump        |     |     |     |     |     |     |
summary        -SUM:prsdump        |     |     |     |     |     |     |
summary        -SUM:securebootcert |     |     |    1|     |     |     |
summary        -SUM:syntaxcheck    |    1|     |     |     |     |     |
summary        -SUM:uefibootpath   |    1|     |     |     |     |     |
summary        -SUM:uefidump       |     |     |     |     |     |     |
summary        -SUM:uefirtmisc     |    2|     |     |     |   10|     |
summary        -SUM:uefirttime     |    2|    2|     |     |     |     |
summary        -SUM:uefirtvariable |   20|     |     |     |     |     |
summary        -SUM:uefivarinfo    |     |     |     |     |     |     |
summary        -SUM:version        |     |     |     |     |    1|    4|
summary        -SUM:wakealarm      |     |     |    4|     |     |     |
summary        -SUM:---------------+-----+-----+-----+-----+-----+-----+
summary        -SUM:Total:         |   77|    6|    5|    2|  186|    8|
summary        -SUM:---------------+-----+-----+-----+-----+-----+-----+


[1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310921.html

Thanks
