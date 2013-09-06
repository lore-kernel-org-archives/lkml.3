Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3IFBKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:10:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35475 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3IFBKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:10:17 -0400
Message-ID: <52292B75.8080705@converseincode.com>
Date: Thu, 05 Sep 2013 21:10:13 -0400
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        charlebm@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: LLVMLinux: Change "extern inline" to "gnu_inline"
 in ARM ftrace.h
References: <1376516261-2071-1-git-send-email-behanw@converseincode.com> <1376516261-2071-2-git-send-email-behanw@converseincode.com> <20130814224552.GA23006@n2100.arm.linux.org.uk>
In-Reply-To: <20130814224552.GA23006@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay. A mistake in my email filters ate all your replies. 
Doh!

On 08/14/13 18:45, Russell King - ARM Linux wrote:
> On Wed, Aug 14, 2013 at 05:37:41PM -0400, behanw@converseincode.com wrote:
>> -extern inline void *return_address(unsigned int level)
>> +extern inline __attribute__((gnu_inline))
>> +void *return_address(unsigned int level)
> Well, that should be static inline, not extern inline in any case.  Does
> clang work if that's static inline?

Actually, neither gcc nor clang work with it merely changed to "static 
inline".

Which is why we left it with the explicit GNU89 meaning of "extern 
inline" which is gnu_inline. C99 changed the meaning of what "extern 
inline" means. One of the major issues we've had with the clang kernel 
port is that clang defaults to gnu99 (which is mostly just C99) while 
until recently gcc defaulted to gnu89.

For recent versions of gcc:

     http://gcc.gnu.org/onlinedocs/gcc/Standards.html

"The default, if no C language dialect options are given, is -std=gnu90; 
this will change to -std=gnu99 or -std=gnu11 in some future release when 
the C99 or C11 support is complete. Some features that are part of the 
C99 standard are accepted as extensions in C90 mode, and some features 
that are part of the C11 standard are accepted as extensions in C90 and 
C99 modes."

However, having said all that, it seems if I remove the corresponding 
NULL definition for return_address in arch/arm/kernel/return_address.c, 
I can make it "static inline" and it seems to work for both gcc and clang.

I'll send a new patch. :)

Incidentally the LLVMLinux project tests all the project's patches with 
both gcc and clang. The idea is to make it work with both compilers 
after all.

Behan

-- 
Behan Webster
behanw@converseincode.com

