Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaDRDZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:25:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43518 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRDZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:25:43 -0400
Message-ID: <53509B30.8070008@hitachi.com>
Date: Fri, 18 Apr 2014 12:25:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534E18B1.4020802@hitachi.com> <534FF43A.109@oracle.com>
In-Reply-To: <534FF43A.109@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/18 0:33), Sasha Levin wrote:
> On 04/16/2014 01:44 AM, Masami Hiramatsu wrote:
>> Same thing can be done in awk part and insn.c, and we can encode it by
>>
>> #define INAT_MAKE_MEMSZ(size) (size << INAT_MEMSZ_OFFS)
>>
>> And decode it by
>>
>> insn->memsz_bytes = 1 << ((attr & INAT_MEMSZ_MASK) >> INAT_MEMSZ_OFFS)
>>
>> Thus, we only need 3 bits to represent 1, 2, 4, 8, 16 and 32. :)
> 
> We'll need 4 so that we could do 64 too :)

Would you mean AVX512? Actually it's not supported currently :(
anyway, that's ok for me, and also, we need another 2 bits for
the operands which depends on address-size prefix and operand-size prefix.

> btw, why aren't we using regular bitfields? this manual encoding
> thingie seems to be a bit confusing (try figuring out how many
> bits are left...).

Ah, right. OK, I'll try to do that :)

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


