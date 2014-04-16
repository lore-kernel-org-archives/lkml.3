Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaDPD1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:27:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37454 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaDPD1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:27:08 -0400
Message-ID: <534DF868.2020901@zytor.com>
Date: Tue, 15 Apr 2014 20:26:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com>
In-Reply-To: <534D4BF3.3020102@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 08:10 AM, Sasha Levin wrote:
> 
> Mnemonics don't have 1:1 relationship with opcodes. So, for example,
> if kmemcheck needs to check (and it does) whether a given instruction
> is an "ADD", it would need to compare it to 9 different opcodes.
> 

Excuse me, but on what planet does, for example, it makes sense if a
particular instruction is a "MOV", for example?  The trend in x86
opcodes have varied over the years and at some points it seems to have
been trendy to have very general mnemonics (consider MOV CR, MOV DR) and
at some points quite the opposite (hence MOVD, MOVQ, MOVDQA, MOVDQU,
MOVAPS, MOVUPS, MOVAPD, MOVUPD, VMOVxxx).

So it is not at all clear that this makes any kind of sense whatsoever,
and is more likely just going to be abused.

	-hpa


