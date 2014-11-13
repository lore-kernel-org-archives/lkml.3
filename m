Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaKMRiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:38:06 -0500
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:22102
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932998AbaKMRiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:38:04 -0500
Message-ID: <5464EC72.7040501@freescale.com>
Date: Thu, 13 Nov 2014 11:37:54 -0600
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>
Subject: Re: [PATCH 3/3 v3] drivers/bus: Device driver for FSL-MC DPRC devices
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com> <1412429015-30564-4-git-send-email-German.Rivera@freescale.com> <545B7CD5.8090802@suse.de>
In-Reply-To: <545B7CD5.8090802@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.88.168.49]
X-ClientProxiedBy: BLUPR08CA0072.namprd08.prod.outlook.com (10.141.200.52) To
 BN3PR0301MB1299.namprd03.prod.outlook.com (25.161.210.154)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1299;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1299;
X-Forefront-PRVS: 0394259C80
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(199003)(51704005)(24454002)(164054003)(189002)(377454003)(479174003)(62966003)(31966008)(21056001)(59896002)(77096003)(77156002)(40100003)(122386002)(99396003)(50986999)(97736003)(87266999)(54356999)(76176999)(65816999)(120916001)(4396001)(50466002)(42186005)(64126003)(23746002)(36756003)(65956001)(66066001)(64706001)(95666004)(19580405001)(19580395003)(80316001)(46102003)(33656002)(20776003)(86362001)(47776003)(102836001)(87976001)(2201001)(92726001)(92566001)(106356001)(101416001)(83506001)(105586002)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1299;H:[10.214.86.152];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1299;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/2014 07:51 AM, Alexander Graf wrote:
>
>
> On 04.10.14 15:23, J. German Rivera wrote:
>> From: "J. German Rivera" <German.Rivera@freescale.com>
>>
>> A DPRC (Data Path Resource Container) is an isolation device
>> that contains a set of DPAA networking devices to be
>> assigned to an isolation domain (e.g., a virtual machine).
>>
>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>> ---
>> Changes in v3:
>> - Addressed comments from Kim Phillips:
>>    * Renamed files:
>>      drivers/bus/fsl-mc/fsl_mc_dprc.c -> drivers/bus/fsl-mc/dprc-driver.c
>>
>> - Addressed comments from Timur Tabi:
>>    * Changed dprc_scan_container() to just return dprc_scan_objects()
>>    * Changed all functions that had goto out/error when no common cleanup
>>      was done, to just have multiple return points.
>>    * Replaced error cleanup boolean flags with multiple exit points.
>>    * REmoved __must_chewck from dprc_scan_*() functions
>>
>> Changes in v2:
>> - Addressed comments from Kim Phillips:
>>    * Fix warning in drivers/bus/fsl-mc/fsl_mc_dprc.c:173
>>    * Fixed linker errors when MC bus driver built as module
>>
>>   drivers/bus/fsl-mc/Makefile      |    3 +-
>>   drivers/bus/fsl-mc/dprc-driver.c |  383 ++++++++++++++++++++++++++++++++++++++
>>   drivers/bus/fsl-mc/mc-bus.c      |    8 +
>>   include/linux/fsl/mc-private.h   |   10 +
>>   4 files changed, 403 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/bus/fsl-mc/dprc-driver.c
>>
>> diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
>> index decd339..424e58e 100644
>> --- a/drivers/bus/fsl-mc/Makefile
>> +++ b/drivers/bus/fsl-mc/Makefile
>> @@ -10,5 +10,6 @@ obj-$(CONFIG_FSL_MC_BUS) += mc-bus-driver.o
>>   mc-bus-driver-objs := mc-bus.o \
>>   		      mc-sys.o \
>>   		      dprc.o \
>> -		      dpmng.o
>> +		      dpmng.o \
>> +		      dprc-driver.o
>>
>> diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
>> new file mode 100644
>> index 0000000..8be6a2a
>> --- /dev/null
>> +++ b/drivers/bus/fsl-mc/dprc-driver.c
>> @@ -0,0 +1,383 @@
>> +/*
>> + * Freescale daata path resource container (DPRC) driver
>
> daata? ;)
>
Fixed.

> Is there any way I can play with this bus? How far do I get with only
> these 3 patches applied today?
>
With these three patches applied you will be able to see the fsl-mc bus 
added in sysfs and the device present in the root DPRC.
Also, since this patch series only contains one MC object driver
(the driver for DPRC objects), you will be able so see that
driver under the fsl-mc bus. Below is a fragment of console
output with an example to illustrate this:

root@ls2085a-simu:~# find /sys/bus/fsl-mc/
/sys/bus/fsl-mc/
/sys/bus/fsl-mc/devices
/sys/bus/fsl-mc/devices/dpbp.1
/sys/bus/fsl-mc/devices/dpio.1
/sys/bus/fsl-mc/devices/dpni.1
/sys/bus/fsl-mc/devices/dprc.1
/sys/bus/fsl-mc/drivers
/sys/bus/fsl-mc/drivers/fsl_mc_dprc
/sys/bus/fsl-mc/drivers/fsl_mc_dprc/bind
/sys/bus/fsl-mc/drivers/fsl_mc_dprc/dprc.1
/sys/bus/fsl-mc/drivers/fsl_mc_dprc/uevent
/sys/bus/fsl-mc/drivers/fsl_mc_dprc/unbind
/sys/bus/fsl-mc/uevent
/sys/bus/fsl-mc/drivers_probe
/sys/bus/fsl-mc/drivers_autoprobe

root@ls2085a-simu:~# ls -l /sys/bus/fsl-mc/devices/dprc.1/
drwxr-xr-x    3 root     root             0 Jan  1  1970 dpbp.1
drwxr-xr-x    3 root     root             0 Jan  1  1970 dpio.1
drwxr-xr-x    3 root     root             0 Jan  1  1970 dpni.1
lrwxrwxrwx    1 root     root             0 Nov  7 20:38 driver -> 
../../../bus/fsl-mc/drivers/fsl_mc_dprc
drwxr-xr-x    2 root     root             0 Nov  7 20:38 power
lrwxrwxrwx    1 root     root             0 Jan  1  1970 subsystem -> 
../../../bus/fsl-mc
-rw-r--r--    1 root     root          4096 Jan  1  1970 uevent

Thanks,

German

>
> Alex
>
