Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbaJ2QAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:00:05 -0400
Received: from mail-bn1on0131.outbound.protection.outlook.com ([157.56.110.131]:11552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933413AbaJ2QAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:00:03 -0400
X-WSS-ID: 0NE7R3W-07-A3L-02
X-M-MSG: 
Message-ID: <54510EFC.2080107@amd.com>
Date: Wed, 29 Oct 2014 10:59:56 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Chen Yucong <slaoub@gmail.com>, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before machine_check_poll()
 resets it
References: <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com> <20141008225750.GH16892@pd.tnic>
 <20141009165339.GA11360@arav-dinar> <20141009173529.GC17647@pd.tnic>
 <5436DB72.1090507@amd.com> <20141021202840.GD4420@pd.tnic>
 <1413942678.17435.11.camel@debian> <20141022081618.GA2511@pd.tnic>
 <1413968014.7070.12.camel@debian> <20141022093042.GB2511@pd.tnic>
In-Reply-To: <20141022093042.GB2511@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(24454002)(51704005)(199003)(479174003)(377454003)(2473001)(189002)(92566001)(92726001)(80316001)(19580395003)(76482002)(21056001)(44976005)(23676002)(86362001)(47776003)(20776003)(64706001)(575784001)(65956001)(50466002)(46102003)(80022003)(64126003)(85852003)(99136001)(84676001)(87936001)(65816999)(83506001)(50986999)(87266999)(54356999)(76176999)(15975445006)(33656002)(36756003)(102836001)(106466001)(95666004)(105586002)(107046002)(97736003)(101416001)(110136001)(93886004)(4396001)(68736004)(85306004)(59896002)(99396003)(120916001)(31966008)(120886001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 4:30 AM, Borislav Petkov wrote:
> Hi Aravind,
>
> question: what's the story with MC?_MISC[IntP], is that bit still there?
> Because I don't see it in my BKDGs here.

Yep, It exists.
Maybe you are referring to Fam15h M0h BKDG? I think the bit was 
introduced only from F15h M30h onwards.
The bit does *not* exist for bank=4, But-
if (bank ==4)
   return true;

takes care of that.

> The background of the story is
>
> https://lkml.org/lkml/2014/10/7/84
>
> There's this thing we did at the time
>
> f227d4306cf3 ("x86, MCE, AMD: Make APIC LVT thresholding interrupt optional")
>
> which, AFAICR, is about some F15h versions having a counter but *not*
> generating a thresholding interrupt. Can you confirm that is still
> the case and we can have a counter but no interrupt gets generated on
> overflow?
>

So yes, moving the assignment inside the if condition should work just fine.

I see the patch on your 'ras-for-3.19' branch does not have this, so 
I'll make this modification
to the branch before I test it.

Thanks,
-Aravind.
