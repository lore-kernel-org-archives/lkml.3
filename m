Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaLVTTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:19:15 -0500
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:23168
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754442AbaLVTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:19:13 -0500
X-WSS-ID: 0NH00BR-07-YWN-02
X-M-MSG: 
Message-ID: <54986EA2.106@amd.com>
Date: Mon, 22 Dec 2014 21:18:58 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Alex Deucher <alexdeucher@gmail.com>
CC: <rusty@rustcorp.com.au>, Dana Elifaz <Dana.Elifaz@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
 <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com>
 <20141222184940.GB17192@tassilo.jf.intel.com>
 <20141222190041.GC17192@tassilo.jf.intel.com>
In-Reply-To: <20141222190041.GC17192@tassilo.jf.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.8.146]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(24454002)(377454003)(189002)(479174004)(199003)(99396003)(50986999)(76176999)(21056001)(87936001)(65806001)(65956001)(19580395003)(19580405001)(36756003)(23746002)(50466002)(64126003)(64706001)(84676001)(83506001)(31966008)(105586002)(120916001)(54356999)(20776003)(77156002)(47776003)(62966003)(65816999)(4396001)(97736003)(93886004)(107046002)(106466001)(46102003)(2950100001)(33656002)(86362001)(68736005)(77096005)(101416001)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB206;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 19:19:05.5706
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/22/2014 09:00 PM, Andi Kleen wrote:
> On Mon, Dec 22, 2014 at 10:49:40AM -0800, Andi Kleen wrote:
>> On Mon, Dec 22, 2014 at 11:58:43AM -0500, Alex Deucher wrote:
>>> On Mon, Dec 22, 2014 at 6:11 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>>> amdkfd driver can be compiled only in 64-bit kernel. Therefore, there is no
>>>> point in trying to initialize amdkfd in 32-bit kernel.
>>>>
>>>> In addition, in case of specific configuration of 32-bit kernel, no modules and
>>>> random kernel base, the symbol_request function doesn't work as expected - It
>>>> doesn't return NULL if the symbol doesn't exists. That makes the kernel panic.
>>>> Therefore, the as amdkfd doesn't compile in 32-bit kernel, the best way is just
>>>> to return false immediately.
>>>>
>>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>>
>>> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
>>
>> Sorry but the patch is just bogus. X-bit only code is usually
>> a very bad sign for the code. This is not windows programing after all.
Hi Andi,

Strange, I have never programmed for Windows in my life (except maybe in a
few courses during my degree) :)
>>
>> Even if you wanted to do a 64bit only driver -- which
>> you probably don't -- the standard way would be to exclude
>> it in Kconfig.
So amdkfd actually *only* supports 64bit user processes, because AMD's HSA
stack on Linux supports *only* 64bit user processes. So, yes, I definitely
want to do a 64bit only driver.
If you look at kfd_open(), it fails the open of /dev/kfd if the process is
32bit.
In addition, in Kconfig of amdkfd, it is written:
"depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64"

The problem here is that there is code in radeon, which is a driver that can
compile in 32bit, which tries to load amdkfd. I didn't see a point in trying
to load a driver which can't be compiled in 32bit.

>>
>> Please root-cause why symbol_request doesn't work on 32bit
>> and fix it properly.
I didn't say it doesn't always work.
The actual thing that doesn't work is the define symbol_get and only in a
specific case of 32bit kernel AND CONFIG_MODULES is unset AND
CONFIG_RANDOMIZE_BASE is set.
The define in that case is:
#define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })

Why it doesn't work (doesn't return NULL when symbol doesn't exists) ?
I don't know, probably because of some elf/makefile/c language magic. I'm
not that big of an expert on those issues, and I wanted to provide a fix for
this problem during the -rc stages. If someone can help me solving the root
cause, I would be more than happy.

	Oded
>>
>> +rusty.
> 
> And also with correct email.
> 
> -Andi
> 
