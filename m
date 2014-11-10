Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaKJQBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:01:17 -0500
Received: from mail-bn1bbn0108.outbound.protection.outlook.com ([157.56.111.108]:45136
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751726AbaKJQBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:01:15 -0500
X-WSS-ID: 0NETZ5T-07-F2L-02
X-M-MSG: 
Message-ID: <5460E13B.4090302@amd.com>
Date: Mon, 10 Nov 2014 10:00:59 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Jan Kiszka" <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
References: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141106163430.GB4737@pd.tnic> <545BA884.5040406@amd.com>
 <20141108090355.GB14837@pd.tnic>
In-Reply-To: <20141108090355.GB14837@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(24454002)(164054003)(377454003)(479174003)(51704005)(64706001)(65806001)(87266999)(106466001)(54356999)(95666004)(86362001)(87936001)(84676001)(62966003)(76176999)(31966008)(21056001)(107046002)(36756003)(4396001)(102836001)(97736003)(92726001)(92566001)(120886001)(65816999)(99396003)(105586002)(50466002)(46102003)(110136001)(44976005)(80316001)(68736004)(59896002)(47776003)(50986999)(20776003)(120916001)(33656002)(77156002)(93886004)(101416001)(83506001)(23676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:3;A:3;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/8/2014 3:03 AM, Borislav Petkov wrote:
> On Thu, Nov 06, 2014 at 10:57:40AM -0600, Aravind Gopalakrishnan wrote:
>> On 11/6/2014 10:34 AM, Borislav Petkov wrote:
>>> On Thu, Nov 06, 2014 at 10:26:22AM -0600, Aravind Gopalakrishnan wrote:
>>>> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
>>>> index e21331c..ba7b609 100644
>>>> --- a/arch/x86/include/uapi/asm/msr-index.h
>>>> +++ b/arch/x86/include/uapi/asm/msr-index.h
>>>> @@ -206,6 +206,8 @@
>>>>   #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
>>>>   #define MSR_AMD64_IBSCTL		0xc001103a
>>>>   #define MSR_AMD64_IBSBRTARGET		0xc001103b
>>>> +#define MSR_AMD64_IBS_FETCH_EXTD_CTL	0xc001103c
>>>> +#define MSR_AMD64_IBSOPDATA4		0xc001103d
>>>>   #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
>>>>   /* Fam 16h MSRs */
>> But Why?
>> IBS_CAPS_BRNTRGT and IBS_CAPS_OPDATA4 indicate support for the respective
>> MSRs
> Ok, I was just making sure.
>
> Btw, MSR_AMD64_IBS_FETCH_EXTD_CTL seems unused. Forgotten?
>

No, There aren't any bits in MSR_AMD64_IBS_FETCH_EXTD_CTL that we need 
to configure right now.
So, have included it here mainly to keep the MSR listing consistent with 
the manual.

Thanks,
-Aravind.
