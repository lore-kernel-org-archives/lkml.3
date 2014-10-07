Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaJGNpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:45:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaJGNpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:45:45 -0400
Message-ID: <5433EE87.2090000@suse.cz>
Date: Tue, 07 Oct 2014 15:45:43 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Check for CONFIG_READABLE_ASM when building .s
 targets
References: <1412523154-25602-1-git-send-email-bp@alien8.de> <20141005155816.GB9377@pd.tnic> <20141007121356.GA18003@sepie.suse.cz> <20141007122707.GD30146@pd.tnic>
In-Reply-To: <20141007122707.GD30146@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-07 14:27, Borislav Petkov wrote:
> On Tue, Oct 07, 2014 at 02:13:56PM +0200, Michal Marek wrote:
>> This violates the principle of least surprise:
>>
>> make $file.s
>> as -o $file.o $file.s
>>
>> should be equivalent to
>>
>> make $file.o
> 
> I know but we need to enable -g for .s targets so that we get the .loc
> annotation (i.e., line numbers) in asm which is very helpful.
> 
> But the least surprise principle is a valid point. Maybe we should warn
> about it too when building .s targets...?
> 
> Or, maybe I should try to find out whether there's another gcc option
> which adds ".loc" annotations alone...

Such option would be best of course. BTW, do you know about make
$file.lst to produce an 'annotated disassembly'?


>> Why not simply check both READABLE_ASM and DEBUG_INFO?  Also, it's more
>> straightforward to print the warning in the top-level Makefile rule than
>> to add a conditional to the generic rule, like this:
> 
> The problem here is that we're building a couple of .s targets
> regardless of what the make command contains, like bounds.s and such.

The toplevel Makefile rule (where your patch adds the asm_target=$@
variable) is only used for manual invocation. bounds.s and the like are
handled by Makefile.build directly.

Michal
