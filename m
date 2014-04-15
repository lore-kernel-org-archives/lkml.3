Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaDOEhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:37:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57707 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaDOEg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:36:27 -0400
X-Greylist: delayed 5048 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 00:36:27 EDT
Message-ID: <534CB744.8090208@hitachi.com>
Date: Tue, 15 Apr 2014 13:36:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com>
In-Reply-To: <534CA38C.80501@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 12:12), Masami Hiramatsu wrote:
> (2014/04/15 2:44), Sasha Levin wrote:
>> arch/x86/lib/x86-opcode-map.txt provides us quite a lot of information about
>> instructions. So far we've discarded information we didn't need to use
>> elsewhere.
>>
>> This patch extracts two more bits of information about instructions:
> 
> These information looks obscure to me. What information (documents)
> does it based on? Could you give me how would you get it?
> 
>>  - Mnemonic. We'd like to refer to instructions by their mnemonic, and not
>> by their opcode. This both makes code readable, and less confusing and
>> prone to typos since a single mnemonic may have quite a few different
>> opcodes representing it.
> 
> I don't like to call it as "mnemonic", it is just "operation".

Ah, I see what you are doing now. Hmm, you'd like to generate a mnemonic-ID
and its macros for each opcode, wouldn't you?
Even though, it seems waste of memory that we have both opcode and mnemonic-ID,
can you integrate that? for example, you can use insn->opcode.value instead of
checking each opcode bytes.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


