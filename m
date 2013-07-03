Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3GCM2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:28:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab3GCM2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:28:17 -0400
Message-ID: <51D418DB.5060102@suse.cz>
Date: Wed, 03 Jul 2013 14:28:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 1/2] Fix a build warning in scripts/sortextable.h
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com> <51D413D9.8040604@suse.cz> <51D41413.9060500@suse.cz> <015BB7AD-78C4-4F1A-B65A-B37FBB6E2B9C@gmail.com>
In-Reply-To: <015BB7AD-78C4-4F1A-B65A-B37FBB6E2B9C@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.7.2013 14:12, Daniel Tang wrote:
>> On 3.7.2013 14:06, Michal Marek wrote:
>>> On 9.6.2013 04:33, Daniel Tang wrote:
>>>> The pointer passed to the _r() macro does not always match the
>>>> type of the function that it is aliasing and raises several of
>>>> the following warnings at compile time:
>>>> 
>>>> warning: passing argument 1 of ‘r8’ from incompatible pointer
>>>> type
>>> 
>>> In what environment (arch, compiler, glibc) are you seeing this?
>>> 
> 
> I'm cross compiling the ARM arch with gcc version 4.7.2 on 64 bit OS
> X. It should throw that warning on any 64 bit environment (not just
> OS X) but I haven't tested it.

The cross compilation target should not matter, this is a host program.
It does work for me on Linux (openSUSE 12.3 FWIW), with gcc 4.7.2 and
glibc 2.17:

$ gcc -m64 -Wall -Wmissing-prototypes -Wstrict-prototypes -O2
-fomit-frame-pointer -Itools/include -o scripts/sortextable
scripts/sortextable.c; echo $?
0

What is the type of Elf64_Shdr::sh_offset in OS X's <elf.h>? In glibc,
this is Elf64_Off, which is a typedef name for uint64_t.

Michal
