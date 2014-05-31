Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbaEaB4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:56:23 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:39725
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755609AbaEaB4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:56:22 -0400
X-WSS-ID: 0N6F1DP-07-BTL-02
X-M-MSG: 
Message-ID: <538936AB.9000005@amd.com>
Date: Fri, 30 May 2014 20:55:55 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 1/4] perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-2-git-send-email-fweisbec@gmail.com>
 <20140530133332.GC25555@localhost.localdomain>
In-Reply-To: <20140530133332.GC25555@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(51704005)(479174003)(377454003)(24454002)(87266999)(77096999)(50466002)(74662001)(68736004)(83072002)(46102001)(84676001)(83506001)(85852003)(87936001)(50986999)(36756003)(86362001)(65816999)(77982001)(76176999)(79102001)(33656002)(92726001)(101416001)(54356999)(80316001)(81342001)(23756003)(83322001)(44976005)(19580395003)(59896001)(74502001)(65956001)(99396002)(97736001)(102836001)(4396001)(76482001)(81542001)(20776003)(47776003)(64706001)(99136001)(21056001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0228DDDDD7
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/30/2014 08:33 AM, Frederic Weisbecker wrote:
>> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
>> >index 4b528a9..145b009 100644
>> >--- a/arch/x86/include/asm/debugreg.h
>> >+++ b/arch/x86/include/asm/debugreg.h
>> >@@ -114,5 +114,10 @@ static inline void debug_stack_usage_inc(void) { }
>> >  static inline void debug_stack_usage_dec(void) { }
>> >  #endif /* X86_64 */
>> >
>> >+#ifdef CONFIG_CPU_SUP_AMD
>> >+extern void set_dr_addr_mask(unsigned long mask, int dr);
>> >+#else
>> >+static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
>> >+#endif
> I see this symbol in the code but it's not defined anywhere in a Kconfig file.
> Maybe you (or I) forgot to include a file in your patches?
>
> Thanks.

If you are referring to the CONFIG_CPU_SUP_AMD, this is in 
arch/x86/Kconfig.cpu

Suravee
