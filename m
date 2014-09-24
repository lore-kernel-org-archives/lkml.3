Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaIXSaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:30:23 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:61419 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXSaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:30:22 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 14:30:22 EDT
Message-ID: <54230C1A.30801@prisktech.co.nz>
Date: Thu, 25 Sep 2014 06:23:22 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Behan Webster <behanw@converseincode.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm, vt8500, LLVMLlinux: Use mcr instead of mcr% for
 mach-vt8500
References: <1411530284-28807-1-git-send-email-behanw@converseincode.com> <7810937.UX61PvX9nB@wuerfel>
In-Reply-To: <7810937.UX61PvX9nB@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24/09/14 21:16, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 20:44:44 Behan Webster wrote:
>> The ASM below does not compile with clang and is not the way that the mcr
>> command is used in other parts of the kernel.
>>
>> arch/arm/mach-vt8500/vt8500.c:72:11: error: invalid % escape in inline assembly string
>>          asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
>>              ~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
>> 1 error generated.
>>
>> There are other forms that are supported on different ARM instruction sets but
>> generally the kernel just uses mcr as it is supported in all ARM instruction
>> sets.
> Just for confirm: both forms are actually correct and we don't need this
> backported for stable, right?
>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
>> Acked-by: Will Deacon <will.deacon@arm.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> Tony, would you like to pick this one up and send it in a pull request
> to arm-soc, or should we apply it to fixes-non-critical directly?
>
> 	Arnd
Arnd,

You can apply it directly to fixes-non-critical if that's ok.

Regards
Tony Prisk
