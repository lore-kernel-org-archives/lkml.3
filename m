Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaKERQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:16:01 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:62176 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbaKERPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:15:52 -0500
MIME-Version: 1.0
In-Reply-To: <545A59D002000078000C1057@mail.emea.novell.com>
References: <5458A12C0200007800044A97@mail.emea.novell.com>
 <545929F9.7010301@amacapital.net> <545A59D002000078000C1057@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 5 Nov 2014 09:15:28 -0800
Message-ID: <CALCETrUh4ghZ9dx4qqjQYGzdhajauX_8UYL+VdopJjTXskTMrw@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86-64: allow using RIP-relative addressing for
 per-CPU data
To: Jan Beulich <jbeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 9:09 AM, Jan Beulich <jbeulich@suse.com> wrote:
>>>> Andy Lutomirski <luto@amacapital.net> 11/04/14 8:33 PM >>>
>>On 11/04/2014 12:49 AM, Jan Beulich wrote:
>>> Observing that per-CPU data (in the SMP case) is reachable by
>>> exploiting 64-bit address wraparound, these two patches
>>> arrange for using the one byte shorter RIP-relative addressing
>>> forms for the majority of per-CPU accesses.
>>>
>>> 1: handle PC-relative relocations on per-CPU data
>>> 2: use RIP-relative addressing for most per-CPU accesses
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>
>>
>>I'm lost here.  Can you give an example of a physical and virtual
>>address of an instruction, the address within the gs segment, and why
>>the relocations are backwards?
>
> When an instruction using RIP relative addressing gets moved up in
> address space, the distance to the target address decreases. I.e. it's the
> opposite of a normal, non-PC-relative base relocation (where the target
> address increases together with the instruction getting moved up).
>

Duh.  Thanks :)

--Andy
