Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKFIvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:51:16 -0500
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:15695
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbaKFIvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:51:15 -0500
X-WSS-ID: 0NEM0L7-07-AUK-02
X-M-MSG: 
Message-ID: <545B3676.9030609@amd.com>
Date: Thu, 6 Nov 2014 10:51:02 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Joerg Roedel <jroedel@suse.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
	<20141027151327.GE9734@suse.de>	<544E61A1.7090400@amd.com>
	<20141027083552.4af5753f@jbarnes-hsw>	<5450B472.1020301@amd.com>
	<20141105120351.GH8354@suse.de> <20141105135109.39ea54fe@jbarnes-hsw>
In-Reply-To: <20141105135109.39ea54fe@jbarnes-hsw>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(52604005)(51704005)(479174003)(189002)(377454003)(199003)(20776003)(47776003)(87936001)(99396003)(62966003)(46102003)(77156002)(65956001)(65806001)(64706001)(95666004)(105586002)(106466001)(21056001)(107046002)(31966008)(120916001)(97736003)(54356999)(87266999)(65816999)(76176999)(50986999)(33656002)(102836001)(101416001)(44976005)(80316001)(19580395003)(19580405001)(59896002)(68736004)(84676001)(83506001)(92726001)(23746002)(86362001)(92566001)(93886004)(64126003)(50466002)(4396001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB202;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB202;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/05/2014 11:51 PM, Jesse Barnes wrote:
> On Wed, 5 Nov 2014 13:03:51 +0100
> Joerg Roedel <jroedel@suse.de> wrote:
>
>> Hi Oded, Jesse,
>>
>> On Wed, Oct 29, 2014 at 11:33:38AM +0200, Oded Gabbay wrote:
>>> I tested our amdkfd driver with your patches applied (kernel 3.17.1).
>>> I run OpenCL tests, Aparapi/Sumatra (Java) and OpenMP
>>>
>>> All tests passed and I didn't see any kernel error messages.
>>>
>>> So:
>>>
>>> Tested-by: Oded Gabbay <oded.gabbay@amd.com>
>>
>> Thanks for testing Oded. Jesse, the patch looks good to me, except the
>> task accounting for the page-faults. I'd like to get rid of using
>> task_struct in the IOMMUv2 driver entirely if possible. Also it is not
>> really the CPU task causing the faults, but some non-CPU process.
>
> Hm, but the CPU task initiates the activity on the GPU, so we should
> account for it somewhere, right?  I guess I had been thinking of the
> "task" as spanning the CPUs and GPUs and other devices in the system,
> rather than just representing the CPU activity.

Joerg, sorry for the dumb question but what do you mean by "task accounting for 
page-faults"? Where is that code in IOMMUv2 driver now ?

>
>> So can you please remove that code and resend the patches with Oded's
>> Tested-by and Andrew Morton on Cc? I think these patches should go
>> through the -mm tree.
>
> Sure, thanks.
>
