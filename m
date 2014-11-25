Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750901AbaKYSPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:15:31 -0500
Received: from mail-bl2on0117.outbound.protection.outlook.com ([65.55.169.117]:27808
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750726AbaKYSP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:15:29 -0500
Message-ID: <5474C733.1010702@freescale.com>
Date: Tue, 25 Nov 2014 12:15:15 -0600
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
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com> <54748D00.1030000@suse.de>
In-Reply-To: <54748D00.1030000@suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BY2PR06CA030.namprd06.prod.outlook.com (10.141.250.148) To
 BN3PR0301MB1297.namprd03.prod.outlook.com (25.161.210.152)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1297;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1297;
X-Forefront-PRVS: 040655413E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(24454002)(189002)(51704005)(199003)(377454003)(479174003)(164054003)(65806001)(42186005)(99396003)(65956001)(66066001)(95666004)(105586002)(77156002)(77096003)(62966003)(31966008)(87976001)(83506001)(122386002)(64126003)(23746002)(40100003)(19580405001)(80316001)(19580395003)(120916001)(97736003)(36756003)(65816999)(50466002)(76176999)(20776003)(54356999)(47776003)(87266999)(33656002)(102836001)(101416001)(4396001)(59896002)(46102003)(92566001)(2201001)(64706001)(50986999)(92726001)(107046002)(86362001)(106356001)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1297;H:[10.214.83.199];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1297;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/25/2014 08:06 AM, Alexander Graf wrote:
>
>
> On 13.11.14 18:54, J. German Rivera wrote:
>> APIs to access the Management Complex (MC) hardware
>> module of Freescale LS2 SoCs. This patch includes
>> APIs to check the MC firmware version and to manipulate
>> DPRC objects in the MC.
>>
>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
>> ---
>> Changes in v4:
>> - Addressed comments from Alex Graf:
>>    * Added file description for files that did not have one
>>    * Removed Marshalling/unmarshalling macros invoked in MC
>>      command wrapper functions, and instead do the marshalling/
>>      unmarshalling directly in these functions.
>>    * Added type cast u32 in status range-check in mc_status_to_error()
>>    * Moved mc_write_command() and mc_read_response() inline
>>      function to mc_sys.c as they are only used in that file
>>    * Renamed u64_enc() as mc_enc() and u64_dec() as mc_dec()
>> - Upgraded MC flibs for MC firmware 0.5
>>
>> Changes in v3:
>> - Addressed comment from Greg Kroah-Hartman:
>>    * Removed doxygen comments
>>
>> - Addressed comment from Scott Wood:
>>    * Replaced udelay() call with usleep_range() call in polling loop
>> - Addressed comments from Kim Phillips:
>>    * Fixed license text in all files
>>    * Renamed files:
>> 	drivers/bus/fsl-mc/fsl_dpmng_cmd.h -> drivers/bus/fsl-mc/dpmng-cmd.h
>> 	drivers/bus/fsl-mc/fsl_dprc_cmd.h -> drivers/bus/fsl-mc/dprc-cmd.h
>> 	drivers/bus/fsl-mc/fsl_mc_sys.c -> drivers/bus/fsl-mc/mc-sys.c
>> 	include/linux/fsl_dpmng.h -> include/linux/fsl/dpmng.h
>> 	include/linux/fsl_dprc.h -> include/linux/fsl/dprc.h
>> 	include/linux/fsl_mc_cmd.h -> include/linux/fsl/mc-cmd.h
>> 	include/linux/fsl_mc_sys.h -> include/linux/fsl/mc-sys.h
>>    * Changed dpmng_load_iop() to take the DMA address directly,
>>      instead of the image virtual address.
>>    * Removed if and WARN_ON that checks for NULL fsl_destroy_mc_io()
>>    * Removed locking from mc_send_command(). Now the caller of MC flib
>>      APIs is responsible for protecting concurrent accesses to the same
>>      MC portal.
>>
>> Changes in v2:
>> - Addressed comment from Joe Perches:
>>    * Refactored logic to actively fail on err and proceed at
>>      the same indent level on success, for all functions in dprc.c
>>      and dpmng.c.
>>
>> - Addressed comments from Kim Phillips:
>>    * Fixed warning in mc_send_command
>>    * Changed serialization logic in mc_send_command() to only use
>>      spinlock_irqsave() when both threads and interrupt handlers
>>      concurrently access the same portal.
>>    * Changed switch to lookup table in mc_status_to_error()
>>    * Removed macros iowrite64(), ioread64(), ENOTSUP from fsl_mc_sys.h
>>    * Removed #ifdef side for FSL_MC_FIRMWARE in fsl_mc_cmd.h
>>    * Changed non-devm_ API calls to devm_ API calls and refactored
>>      fsl_create_mc_io()/fsl_destroy_mc_io() to simplify cleanup logic.
>>
>> - Addressed comments from Scott Wood:
>>    * Return -ENXIO instead of -EFAULT when ioremap_nocache() fails
>>
>> - Addressed comments from Alex Graf:
>>    * Added MAINTAINERS file entries for new files
>>    * Added dev param to fsl_create_mc_io(), to enable the use
>>      of devm_ APIs in this function and fsl_destroy_mc_io().
>>    * Changed the value of the timeout for MC command completion
>>      to be a function of HZ instead of a hard-coded jiffies value.
>>
>>   MAINTAINERS                    |   8 +
>>   drivers/bus/fsl-mc/dpmng-cmd.h |  50 +++
>>   drivers/bus/fsl-mc/dpmng.c     | 126 ++++++
>>   drivers/bus/fsl-mc/dprc-cmd.h  |  85 ++++
>>   drivers/bus/fsl-mc/dprc.c      | 933 +++++++++++++++++++++++++++++++++++++++++
>>   drivers/bus/fsl-mc/mc-sys.c    | 284 +++++++++++++
>>   include/linux/fsl/dpmng.h      | 151 +++++++
>>   include/linux/fsl/dprc.h       | 868 ++++++++++++++++++++++++++++++++++++++
>>   include/linux/fsl/mc-cmd.h     | 109 +++++
>>   include/linux/fsl/mc-sys.h     |  70 ++++
>>   10 files changed, 2684 insertions(+)
>>   create mode 100644 drivers/bus/fsl-mc/dpmng-cmd.h
>>   create mode 100644 drivers/bus/fsl-mc/dpmng.c
>>   create mode 100644 drivers/bus/fsl-mc/dprc-cmd.h
>>   create mode 100644 drivers/bus/fsl-mc/dprc.c
>>   create mode 100644 drivers/bus/fsl-mc/mc-sys.c
>>   create mode 100644 include/linux/fsl/dpmng.h
>>   create mode 100644 include/linux/fsl/dprc.h
>>   create mode 100644 include/linux/fsl/mc-cmd.h
>>   create mode 100644 include/linux/fsl/mc-sys.h
>>
>
> [...]
>
>> +/**
>> + * Sends an command to the MC device using the given MC I/O object
>> + *
>> + * @mc_io: MC I/O object to be used
>> + * @cmd: command to be sent
>> + *
>> + * Returns '0' on Success; Error code otherwise.
>> + *
>> + * NOTE: This function cannot be invoked from from atomic contexts.
>> + */
>> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
>> +{
>> +	enum mc_cmd_status status;
>> +	unsigned long irqsave_flags = 0;
>
> drivers/bus/fsl-mc/mc-sys.c: In function ‘mc_send_command’:
> drivers/bus/fsl-mc/mc-sys.c:235:16: warning: unused variable
> ‘irqsave_flags’ [-Wunused-variable]
>    unsigned long irqsave_flags = 0;
>
I'll fix this in the next respin.

Thanks,

German
                 ^
>
>
> Alex
>
