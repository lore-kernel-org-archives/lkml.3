Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBYCeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:34:18 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36268 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaBYCeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:34:17 -0500
Message-ID: <530C0112.4070503@converseincode.com>
Date: Mon, 24 Feb 2014 18:33:54 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>, rob@landley.net,
        rdunlap@infradead.org, geert@linux-m68k.org
CC: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>
Subject: Re: [PATCH] module: LLVMLinux: Fix section mismatch issues on alias
 usage
References: <1392956909-22715-1-git-send-email-behanw@converseincode.com> <53076BDE.5000205@windriver.com>
In-Reply-To: <53076BDE.5000205@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/14 07:08, Paul Gortmaker wrote:
>> Attribute aliases don't inherit the link section name when compiled with clang.
>> As a result, the linking section needs to be explicitly specified when building
>> a module. This behavior is undefined in the standard which is why it differs from
>> compiler to compiler.
> But is there a good reason why clang doesn't inherit them in the
> interest of compatibility with gcc and existing code?
There is no reason other than it doesn't appear to be documented 
behaviour anywhere that can be found. It seems like this use of an 
aliased symbol inheriting attributes never came up before. Personally I 
think the kernel code pushes compilers harder than most other code bases. :)

Having said that, it seems since we first started needing this patch to 
build the kernel with clang, this issue may have been fixed in the most 
recent updates to clang in the last few weeks. I've been testing with 
the latest released version of clang v3.4 (since clang recently when 
through a merge window of their own) which still requires this patch. 
However in appears that this issue may now have been fixed in mainline 
clang. I'll do some more testing to verify and get back to this thread.

> I know we've seen the faceless entity "PaX Team" before, but can we 
> please not make it worse by adding a bunch of other non standard tag 
> line formats? And ideally have a real human name for the author too.
Fair enough. Will fix and resubmit if the patch proves to still be 
necessary.

Thanks for the input,

Behan

-- 
Behan Webster
behanw@converseincode.com

