Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaLVJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:26:24 -0500
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:33298
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754003AbaLVJ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:26:21 -0500
X-WSS-ID: 0NGZ8VO-08-95J-02
X-M-MSG: 
Message-ID: <5497E3A6.7070600@amd.com>
Date: Mon, 22 Dec 2014 11:25:58 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [drm/radeon] BUG: unable to handle kernel paging request
 at 03200000
References: <1418890668.26403.6.camel@intel.com> <54928E6B.1020501@amd.com>
 <1418891181.26403.9.camel@intel.com>
In-Reply-To: <1418891181.26403.9.camel@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(69234005)(51704005)(24454002)(377454003)(479174004)(377424004)(164054003)(199003)(189002)(62966003)(77156002)(54356999)(101416001)(76176999)(87266999)(23676002)(64126003)(59896002)(50466002)(68736005)(50986999)(65806001)(65956001)(15975445007)(31966008)(77096005)(575784001)(21056001)(87936001)(99396003)(110136001)(92566001)(2950100001)(86362001)(20776003)(83506001)(107046002)(97736003)(4396001)(46102003)(120916001)(36756003)(47776003)(64706001)(105586002)(106466001)(80316001)(33656002)(19580405001)(84676001)(19580395003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB203;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 09:26:18.6929
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/18/2014 10:26 AM, Huang Ying wrote:
> On Thu, 2014-12-18 at 10:20 +0200, Oded Gabbay wrote:
>> On 12/18/2014 10:17 AM, Huang Ying wrote:
>>> FYI, we noticed the below changes on
>>>
>>> commit e28740ece34d314002b1ddfa14e8fb7c7b909489 ("drm/radeon: Add radeon <--> amdkfd interface")
>>>
>>>
>>> +------------------------------------------+------------+------------+
>>> |                                          | 1c0a46255f | e28740ece3 |
>>> +------------------------------------------+------------+------------+
>>> | boot_successes                           | 0          | 0          |
>>> | boot_failures                            | 10         | 13         |
>>> | BUG:kernel_boot_hang                     | 9          | 9          |
>>> | INFO:suspicious_RCU_usage                | 1          | 3          |
>>> | backtrace:do_fork                        | 1          | 3          |
>>> | BUG:unable_to_handle_kernel              | 0          | 3          |
>>> | Oops                                     | 0          | 3          |
>>> | Kernel_panic-not_syncing:Fatal_exception | 0          | 3          |
>>> | backtrace:radeon_init                    | 0          | 3          |
>>> | backtrace:kernel_init_freeable           | 0          | 3          |
>>> | BUG:kernel_boot_crashed                  | 0          | 1          |
>>> +------------------------------------------+------------+------------+
>>>
>>>
>>> [    5.407193] Linux agpgart interface v0.103
>>> [    5.428469] [drm] Initialized drm 1.1.0 20060810
>>> [    5.438456] [drm] radeon kernel modesetting enabled.
>>> [    5.439741] BUG: unable to handle kernel paging request at 03200000
>>> [    5.440063] IP: [<03200000>] 0x3200000
>>> [    5.440063] *pde = 00000000
>>> [    5.440063] Oops: 0000 [#1] SMP
>>> [    5.440063] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-g603ba7e #14
>>> [    5.440063] task: 42e08000 ti: 42e02000 task.ti: 42e02000
>>> [    5.440063] EIP: 0060:[<03200000>] EFLAGS: 00010246 CPU: 0
>>> [    5.440063] EIP is at 0x3200000
>>> [    5.440063] EAX: 00000001 EBX: 00000000 ECX: 4738b460 EDX: 45735a64
>>> [    5.440063] ESI: 4662d0dd EDI: 401fafa0 EBP: 42e03f20 ESP: 42e03f18
>>> [    5.440063]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>>> [    5.440063] CR0: 8005003b CR2: 03200000 CR3: 067f0000 CR4: 00000690
>>> [    5.440063] Stack:
>>> [    5.440063]  44bf19b1 00000000 42e03f28 4662d20b 42e03f8c 465b6e5d 00000000 00000000
>>> [    5.440063]  00000000 00000000 00000000 00000000 000000ea 00000000 00000000 00000101
>>> [    5.440063]  45f2dfba 00000010 00000012 00000200 47fdcf54 47fdcf54 00000006 00000291
>>> [    5.440063] Call Trace:
>>> [    5.440063]  [<44bf19b1>] ? radeon_kfd_init+0x67/0xab
>>> [    5.440063]  [<4662d20b>] radeon_init+0x12e/0x15c
>>> [    5.440063]  [<465b6e5d>] do_one_initcall+0x25f/0x41e
>>> [    5.440063]  [<465b7291>] kernel_init_freeable+0x275/0x423
>>> [    5.440063]  [<455b4e52>] kernel_init+0x1c/0x293
>>> [    5.440063]  [<455df181>] ret_from_kernel_thread+0x21/0x30
>>> [    5.440063]  [<455b4e36>] ? rest_init+0x33e/0x33e
>>> [    5.440063] Code:  Bad EIP value.
>>> [    5.440063] EIP: [<03200000>] 0x3200000 SS:ESP 0068:42e03f18
>>> [    5.440063] CR2: 0000000003200000
>>> [    5.440063] ---[ end trace 1959b295b01c0c14 ]---
>>> [    5.440063] Kernel panic - not syncing: Fatal exception
>>>
>>>
>>> Thanks,
>>> Huang, Ying
>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> LKP mailing list
>>> LKP@linux.intel.com
>>>
>>
>> Is this a 32-bit kernel ?
>> Is amdkfd compiled ?
>
> The kconfig file is attached in the original email.  From it, it is
> 32-bit kernel.  I don't find AMDKFD in config file.  Could you help me
> to check it?
>
> Best Regards,
> Huang, Ying
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
OK, I found the culprit.
If you define 32-bit kernel, No modules and random kernel base, than the 
symbol_request function doesn't return NULL if the symbol doesn't exists, which 
causes the rest of the code to have undefined results.

I prepared a patch to fix it and hopefully it will be in -rc2. I will sent it to 
dri-devel as usual.

	Oded
