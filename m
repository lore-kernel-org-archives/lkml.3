Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaEUHkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:40:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50066 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaEUHka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:40:30 -0400
Message-ID: <537C5868.7020302@hitachi.com>
Date: Wed, 21 May 2014 16:40:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] x86: extend insn decoder to understand xop and evex
 prefixes
References: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com> <1400265279-22503-2-git-send-email-dvlasenk@redhat.com> <537787A8.7000709@hitachi.com> <537A1D93.7030601@redhat.com>
In-Reply-To: <537A1D93.7030601@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/20 0:04), Denys Vlasenko wrote:
> On 05/17/2014 06:00 PM, Masami Hiramatsu wrote:
>> (2014/05/17 3:34), Denys Vlasenko wrote:
>>> Since xop and evex prefixes are extensions of vex mechanism,
>>> they have similar bit layouts, and they can never be combined
>>> (an instruction can have only one of them),
>>> (ab)use insn->vex_prefix to store data of xop and evex too.
>>>
>>> Users will need to conditionalize on insn->vex_prefix.bytes[0]
>>> instead of insn->vex_prefix.nbytes if they want to determine
>>> which of vex(-like) prefixes are there.
>>>
>>> Instead of adding more inattr bits for these prefixes, drop
>>> VEX inattr bits and use VEX opcode values directly to detect them.
>>> There is no point in having additional level of indirection here.
>>> (And we are close to running out of inattr bits for prefixes).
>>
>> Thank you very much for trying this work :)
>> But sorry, Nak, I don't like to use the prefix byte directly.
>> I'd rather like to add additional inattr bits for them.
> 
> Ok, I'm looking at inat.h and looks like I need to widen
> INAT_PFX_BITS, otherwise I have no space for two more bits
> for two more prefixes (XOP and EVEX):

Yes, that's what I look forward! :)

> 
> /* AVX VEX prefixes */
> #define INAT_PFX_VEX2   13      /* 2-bytes VEX prefix */
> #define INAT_PFX_VEX3   14      /* 3-bytes VEX prefix */
> ...
> 
> /* Legacy prefix */
> #define INAT_PFX_OFFS   0
> #define INAT_PFX_BITS   4
> #define INAT_PFX_MAX    ((1 << INAT_PFX_BITS) - 1)
> #define INAT_PFX_MASK   (INAT_PFX_MAX << INAT_PFX_OFFS)
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


