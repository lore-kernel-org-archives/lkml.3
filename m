Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3GCNQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:16:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab3GCNQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:16:01 -0400
Message-ID: <51D4240D.3050708@suse.cz>
Date: Wed, 03 Jul 2013 15:15:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 1/2] Fix a build warning in scripts/sortextable.h
References: <1370745235-12951-1-git-send-email-dt.tangr@gmail.com> <51D413D9.8040604@suse.cz> <51D41413.9060500@suse.cz> <015BB7AD-78C4-4F1A-B65A-B37FBB6E2B9C@gmail.com> <51D418DB.5060102@suse.cz> <E04C38F7-0FF7-4B8A-8A3B-9EC135BFEB4F@gmail.com> <51D41FA7.80209@suse.cz>
In-Reply-To: <51D41FA7.80209@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.7.2013 14:57, Michal Marek wrote:
> On 3.7.2013 14:37, Daniel Tang wrote:
>> Hi,
>>
>> On 03/07/2013, at 10:28 PM, Michal Marek <mmarek@suse.cz> wrote:
>>>
>>>
>>> What is the type of Elf64_Shdr::sh_offset in OS X's <elf.h>? In
>>> glibc, this is Elf64_Off, which is a typedef name for uint64_t.
>>
>> Huh, that's weird. Elf64_Off is defined as unsigned long in my elf.h
>> which isn't 64 bit on x86_64 pretty sure.
> 
> unsigned long _is_ 64bit on x86_64 Linux (or any 64bit Linux), but it
> might not be the case on OS X. But then, the <elf.h> on that platform
> should use something that is actually 64bit for Elf64_Off.

Hm, according to
https://developer.apple.com/library/mac/documentation/Darwin/Conceptual/64bitPorting/transition/transition.html,
64bit OS X uses that same model as Linux, i.e. sizeof(long) ==
sizeof(void*). So the warning is probably caused by the fact that the
typedefs Elf64_Off and uint64_t are not identical (even though the types
have the same size). How are these defined on OS X?

Thanks,
Michal
