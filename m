Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaJBDZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:25:23 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:56929 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaJBDZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:25:21 -0400
Message-ID: <542CC595.1050102@roeck-us.net>
Date: Wed, 01 Oct 2014 20:25:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: atull@opensource.altera.com, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, lgirdwood@gmail.com, broonie@kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 0/4] regulator support for pmbus and ltc2978
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.542CC5A1.003F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 12:05 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
>
> This set of patches adds regulator support for pmbus_core.c and ltc2978.c
>
> Each output has individual on/off control.
>
>>From PMBus_Specification_Part_II_Rev_1-3_20140318.pdf:
> 12.1.1. OPERATION Command Bit [7]
>    Bit [7] controls whether the PMBus device output is on or off.
>     If bit [7] is cleared (equals 0), then the output is off.
>     If bit [7] is set (equals 1), then the output is on.
>
> Fixes in v4 are not huge:
>    Add device tree bindings documentation for ltc2978.
>    rename _pmbus_regulator_enable to _pmbus_regulator_on_off
>    simplify _pmbus_regulator_on_off code
>    s/regulator_regulator/regulator/
>    fix build break when !CONFIG_REGULATOR
>    remove unused #define PB_OPERATION_CONTROL_SEQ_OFF
>    fix a #endif comment
>    simplify probe code, remove added switch statement
>    remove BUG_ON(), add error message and fix num_regulators
>
> Patch 1: document device tree bindings for ltc2978
>
> Patch 2: add two helper functions for byte pmbus byte operations
>    * byte write and byte read/modify/write
>
> Patch 3: regulator support added in pmbus_core.c and pmbus.h
>    * regulator_ops functions (is_enabled, enable, and disable)
>    * gets regulator init data from device tree or platform data
>    * registers the regulators
>    * header has a macro for chip drivers to build their
>      regulator_desc data
>
> Patch 4: changes for ltc2978.c
>    * Add Kconfig to enable/disable ltc2978 regulator functionality
>    * add regulator_desc and of_regulator_match info
>    * use same structs for all parts; set num_regulators appropriately.
>
> Alan Tull (3):
>    pmbus: core: add helpers for byte write and read modify write
>    pmbus: add regulator support
>    pmbus: ltc2978: add regulator support
>
> Alan Tull (4):
>    hwmon: ltc2978: device tree bindings documentation
>    pmbus: core: add helpers for byte write and read modify write
>    pmbus: add regulator support
>    pmbus: ltc2978: add regulator support
>
>   .../devicetree/bindings/hwmon/ltc2978.txt          |   42 +++++
>   drivers/hwmon/pmbus/Kconfig                        |    7 +
>   drivers/hwmon/pmbus/ltc2978.c                      |   37 +++++
>   drivers/hwmon/pmbus/pmbus.h                        |   26 ++++
>   drivers/hwmon/pmbus/pmbus_core.c                   |  160 ++++++++++++++++++++
>   include/linux/i2c/pmbus.h                          |    4 +
>   6 files changed, 276 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
>

Overall looks ok. There is a whitespace error in patch #1, and the revision history
should be after --- since we don't want it in the commit log. I fixed those up,
and applied the series to my local hwmon-next branch. I'll do some more testing
on a real system and then push it into -next. That should happen tomorrow
unless I encounter some problems.

We can take care of the Kconfig messages with a follow-up patch.

Thanks,
Guenter

