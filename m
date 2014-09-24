Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaIXS1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:27:11 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54030 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaIXS1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:27:09 -0400
Message-ID: <54230CFA.10003@converseincode.com>
Date: Wed, 24 Sep 2014 11:27:06 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: mq@suse.cz, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Tom Gundersen <teg@jklm.no>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>, fengguang.wu@intel.com
Subject: Re: [PATCH] kbuild, LLVMLinux: Fix asm-offset generation to work
 with clang
References: <1411500331-9861-1-git-send-email-behanw@converseincode.com> <3907075.FRP0QfugZW@wuerfel>
In-Reply-To: <3907075.FRP0QfugZW@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 03:37, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 12:25:31 behanw@converseincode.com wrote:
>>   #define DEFINE(sym, val) \
>> -        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
>> +       asm volatile("\n@->" #sym " %0 " #val : : "i" (val))
> Isn't the '@' character to start a comment architecture specific?
I had worried about that as well (as we discussed at LCU), but with the 
limited testing I tried this with it seemed to indicate that gas was 
smart enough to handle it in most cases. However the kbuild test robot 
indicates that this patch breaks MIPS. So indeed your concern is justified.

Gotta love the kbuild test robot. Thank you Fengguang Wu!

> If this makes it work on ARM, what about other architectures?
For now, I think I need to try something else.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

