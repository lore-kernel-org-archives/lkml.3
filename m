Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaIXSu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:50:58 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47445 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaIXSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:50:57 -0400
Message-ID: <5423128D.8070708@converseincode.com>
Date: Wed, 24 Sep 2014 11:50:53 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: ak@linux.intel.com, yamada.m@jp.panasonic.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] kbuild, LLVMLinux: Add -Werror to cc-option to support
 clang
References: <1411500522-11480-1-git-send-email-behanw@converseincode.com> <5422B3EF.4000800@suse.cz>
In-Reply-To: <5422B3EF.4000800@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 05:07, Michal Marek wrote:
> On 2014-09-23 21:28, behanw@converseincode.com wrote:
>> From: Mark Charlebois <charlebm@gmail.com>
>>
>> Clang will warn about unknown warnings but will not return false
> You mean unknown options, right?
2 kinds of options: flags and warnings. clang used to merely warn about 
unused/unsupported flags/warnings. It now returns errors for unknown 
flags, but not warnings (unless you specify -Werror).

The issue is that a lot of existing projects which use clang expect the 
former behaviour (I agree that makes no sense, but there you go).

>> unless -Werror is set. GCC will return false if an unknown
>> warning is passed.
>>
>> Adding -Werror make both compiler behave the same.
> Can you please limit it to the clang case? Add an internal variable that
> either contains -Werror or nothing, depending on the compiler.
I can do that. Will fix.

>   What I
> fear is that if we use -Werror unconditionally and the user (or some
> automated build system) decides to add some silly option to KCFLAGS, we
> will get silent failures in the cc-option tests.
A valid concern for sure.

> BTW, is there a chance that this would be fixed in some later clang
> version? Accepting unknown commandline options is a rather unusual
> behavior. How are all the ./configure scripts going to cope with it?
Again, clang does error out on unknown compiler flags (as opposed to 
warnings).

Getting clang to error on unused flags wasn't trivial (this change broke 
a lot of builds apparently). Fortunately we weren't the only ones who 
wanted it to behave like gcc in this case. I think it's going to be 
*much* harder to do the same for warnings. The argument given by 
supporters of the current situation is that if a warning isn't 
supported, why break the build? *sigh*

The LLVMLinux project is pushing hard to fix these sorts of things in 
clang, but some changes are more likely than others.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

