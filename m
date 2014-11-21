Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbaKUP1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:27:38 -0500
Received: from mail-by2on0087.outbound.protection.outlook.com ([207.46.100.87]:17536
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755321AbaKUP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:27:36 -0500
Message-ID: <546F59DD.5040809@opensource.altera.com>
Date: Fri, 21 Nov 2014 09:27:25 -0600
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux@arm.linux.org.uk>, <dinh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: socfpga: Set share override bit of the l2 cache
 controller
References: <1416546280-12068-1-git-send-email-dinguyen@opensource.altera.com> <1416546280-12068-2-git-send-email-dinguyen@opensource.altera.com> <2156186.zs80uXCLAf@wuerfel>
In-Reply-To: <2156186.zs80uXCLAf@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.103.66.154]
X-ClientProxiedBy: BLUPR11CA0006.namprd11.prod.outlook.com (10.141.240.16) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 0402872DA1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(479174003)(377454003)(164054003)(24454002)(199003)(19580395003)(97736003)(80316001)(19580405001)(31966008)(4396001)(50466002)(23756003)(76176999)(64126003)(65816999)(83506001)(101416001)(102836001)(87266999)(21056001)(33656002)(86362001)(50986999)(87976001)(54356999)(92726001)(92566001)(40100003)(59896002)(77156002)(62966003)(77096003)(120916001)(99396003)(65956001)(122386002)(105586002)(66066001)(106356001)(64706001)(47776003)(20776003)(107046002)(95666004)(42186005)(46102003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 11/21/14, 5:04 AM, Arnd Bergmann wrote:
> On Thursday 20 November 2014 23:04:40 dinguyen@opensource.altera.com wrote:
>>
>> ---
>>  arch/arm/mach-socfpga/socfpga.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
>> index 13b1858..afc009f 100644
>> --- a/arch/arm/mach-socfpga/socfpga.c
>> +++ b/arch/arm/mach-socfpga/socfpga.c
>> @@ -105,7 +105,8 @@ static const char *altera_dt_match[] = {
>>  
>>  DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
>>         .l2c_aux_val    = L310_AUX_CTRL_DATA_PREFETCH |
>> -                         L310_AUX_CTRL_INSTR_PREFETCH,
>> +                         L310_AUX_CTRL_INSTR_PREFETCH |
>> +                         L2C_AUX_CTRL_SHARED_OVERRIDE,
>>         .l2c_aux_mask   = ~0,
>>         .smp            = smp_ops(socfpga_smp_ops),
>>         .map_io         = socfpga_map_io,
> 
> Hi Dinh,
> 
> Please do this by putting the appropriate proterties into the
> l2x0 DT node instead.
> 

I don't see a way to do this yet in DT. Perhaps I'm missing a patchset
to allow this?

Thanks,
Dinh
