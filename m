Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbaDXNTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:19:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55008 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaDXNTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:19:21 -0400
Message-ID: <53590F33.6070508@ti.com>
Date: Thu, 24 Apr 2014 09:18:43 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 4/6] soc: ti: add Keystone Navigator QMSS driver
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com> <1398296783-1176-5-git-send-email-santosh.shilimkar@ti.com> <20140424013053.GC13374@saruman.home>
In-Reply-To: <20140424013053.GC13374@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 09:30 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Apr 23, 2014 at 07:46:20PM -0400, Santosh Shilimkar wrote:
>> From: Sandeep Nair <sandeep_n@ti.com>
>>
>> The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
>> the main hardware sub system which forms the backbone of the Keystone
>> Multi-core Navigator. QMSS consist of queue managers, packed-data structure
>> processors(PDSP), linking RAM, descriptor pools and infrastructure
>> Packet DMA.
>>
>> The Queue Manager is a hardware module that is responsible for accelerating
>> management of the packet queues. Packets are queued/de-queued by writing or
>> reading descriptor address to a particular memory mapped location. The PDSPs
>> perform QMSS related functions like accumulation, QoS, or event management.
>> Linking RAM registers are used to link the descriptors which are stored in
>> descriptor RAM. Descriptor RAM is configurable as internal or external memory.
>>
>> The QMSS driver manages the PDSP setups, linking RAM regions,
>> queue pool management (allocation, push, pop and notify) and descriptor
>> pool management. The specifics on the device tree bindings for
>> QMSS can be found in:
>> 	Documentation/devicetree/bindings/soc/keystone-navigator-qmss.txt
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: Olof Johansson <olof@lixom.net>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> ---
>>  drivers/Kconfig                  |    2 +
>>  drivers/soc/Kconfig              |    2 +
>>  drivers/soc/Makefile             |    5 +
>>  drivers/soc/ti/Kconfig           |   21 +
>>  drivers/soc/ti/Makefile          |    4 +
>>  drivers/soc/ti/knav_qmss.h       |  386 ++++++++
>>  drivers/soc/ti/knav_qmss_acc.c   |  591 +++++++++++++
>>  drivers/soc/ti/knav_qmss_queue.c | 1814 ++++++++++++++++++++++++++++++++++++++
>>  include/linux/soc/ti/knav_qmss.h |   90 ++
>>  9 files changed, 2915 insertions(+)
>>  create mode 100644 drivers/soc/Makefile
>>  create mode 100644 drivers/soc/ti/Kconfig
>>  create mode 100644 drivers/soc/ti/Makefile
>>  create mode 100644 drivers/soc/ti/knav_qmss.h
>>  create mode 100644 drivers/soc/ti/knav_qmss_acc.c
>>  create mode 100644 drivers/soc/ti/knav_qmss_queue.c
>>  create mode 100644 include/linux/soc/ti/knav_qmss.h
>>
>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index 0e87a34..8993913 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -148,6 +148,8 @@ source "drivers/remoteproc/Kconfig"
>>  
>>  source "drivers/rpmsg/Kconfig"
>>  
>> +source "drivers/soc/Kconfig"
> 
> This hunk was already in patch one but in a different offset in this
> file.
> 
right.. I will drop this one... Thanks for spotting it
