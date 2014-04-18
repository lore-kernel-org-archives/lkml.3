Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaDRQtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:49:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41186 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbaDRQtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:49:25 -0400
Message-ID: <53515775.2080604@zytor.com>
Date: Fri, 18 Apr 2014 09:48:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com> <534E1559.8050904@hitachi.com> <534FF135.40404@oracle.com> <534FF31E.1000104@zytor.com> <53500FF8.8010804@oracle.com> <53509EB9.5070001@hitachi.com> <53509FD9.2020803@zytor.com> <5351491F.3030309@oracle.com>
In-Reply-To: <5351491F.3030309@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 08:47 AM, Sasha Levin wrote:
> 
> There are very specific mnemonics that kmemchecks wants to detect and treat
> as a corner case.
> 
> What you're saying here is that while the instruction decoder already has the
> knowledge of mnemonics, kmemcheck shouldn't use it and instead write it's own
> opcode -> mnemonic parser and use that instead.
> 

I think that involving mnemonics is "bonghits" level of crazy.  It's a
solution in search of the problem, but it is a hack, and a pretty
horrific one.

> 
>> What it sounds like it really wants is a "bitwise" flag on the instruction.
> 
> A flag like that would solve part of the problem (we'd still need to work with
> CMPS and MOVS), and sounds very kmemcheck specific.
> 

Well, guess what, the whole point is to export information to the users
that need it.

	-hpa


