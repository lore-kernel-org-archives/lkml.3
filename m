Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaAPPeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:34:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaAPPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:34:20 -0500
Message-ID: <52D7FBF7.2070508@suse.cz>
Date: Thu, 16 Jan 2014 16:34:15 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
CC: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/gcc-version.sh: handle CC="gcc -m32"
References: <87d2l5ji06.fsf@rustcorp.com.au> <52C6EF1C.9070809@suse.cz> <52C71EDA.6090706@suse.cz> <87k3e1x4ho.fsf@rustcorp.com.au>
In-Reply-To: <87k3e1x4ho.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.1.2014 05:18, Rusty Russell wrote:
> Michal Marek <mmarek@suse.cz> writes:
>> On 3.1.2014 18:10, Michal Marek wrote:
>>> On 2013-12-10 08:13, Rusty Russell wrote:
>>>> Without it we get ugly warnings (though build still succeeds).
>>>>
>>>> $ make -j8 CC="gcc -m32"
>>>> In file included from <command-line>:0:0:
>>>> /usr/include/stdc-predef.h:30:26: fatal error: bits/predefs.h: No such file or directory
>>>>  #include <bits/predefs.h>
>>>>                           ^
>>>> compilation terminated.
>>>> In file included from <command-line>:0:0:
>>>> /usr/include/stdc-predef.h:30:26: fatal error: bits/predefs.h: No such file or directory
>>>>  #include <bits/predefs.h>
>>>>                           ^
>>>> compilation terminated.
>>>> /home/rusty/devel/kernel/linux/scripts/gcc-version.sh: line 31: printf: #: invalid number
>>>> /home/rusty/devel/kernel/linux/scripts/gcc-version.sh: line 31: printf: #: invalid number
>>>> /bin/sh: 1: [: 0001: unexpected operator
>>>>   CHK     include/config/kernel.release
>>>>   CHK     include/generated/uapi/linux/version.h
>>>> make[1]: Nothing to be done for `all'.
>>>> ...
>>>>
>>>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>>>
>>>> diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
>>>> index 7f2126df91f2..d48b0cbaf246 100644
>>>> --- a/scripts/gcc-version.sh
>>>> +++ b/scripts/gcc-version.sh
>>>> @@ -14,7 +14,7 @@ if [ "$1" = "-p" ] ; then
>>>>  	shift;
>>>>  fi
>>>>  
>>>> -compiler="$*"
>>>> +compiler="$1"
>>>
>>> But this will break things like CC="ccache gcc". Your problem is that
>>> you do not have the 32bit glibc headers, right?
>>
>> BTW, what is the usecase for CC="gcc -m32"? AFAICS, at least x86 and
>> powerpc do this for you when building a 32bit kernel.
> 
> No, without -m32 I get:
> 
> $ make
> make[1]: Nothing to be done for `all'.
> make[1]: Nothing to be done for `relocs'.
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CC      kernel/bounds.s
> gcc: warning: ‘-mcpu=’ is deprecated; use ‘-mtune=’ or ‘-march=’ instead
> gcc: warning: ‘-mcpu=’ is deprecated; use ‘-mtune=’ or ‘-march=’ instead
> kernel/bounds.c:1:0: error: CPU you selected does not support x86-64 instruction set
>  /*
>  ^
> kernel/bounds.c:1:0: warning: -mregparm is ignored in 64-bit mode [enabled by default]
> make[1]: *** [kernel/bounds.s] Error 1
> make: *** [prepare0] Error 2
> 
> If that's *supposed* to work, then the bug is elsewhere.

It is supposed to work, but I have no idea what's going on here. Please
provide output of
$ uname -m
$ gcc -v
$ make V=1
$ cat .config

and we will see.

Michal
