Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3KNBOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:14:48 -0500
Received: from intranet.asianux.com ([58.214.24.6]:38066 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3KNBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:14:41 -0500
X-Spam-Score: -100.8
Message-ID: <52842481.1000802@asianux.com>
Date: Thu, 14 Nov 2013 09:16:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: =?UTF-8?B?SMOldmFyZCBTa2lubmVtb2Vu?= <hskinnemoen@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>,
        eliezer.tamir@linux.intel.com, bernat@luffy.cx, therbert@google.com,
        jacob.e.keller@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: Re: [PATCH] arch: avr32: uapi: be sure of "_UAPI" prefix for all
 guard macros
References: <5281E917.4030408@asianux.com> <20131113112126.GA854@samfundet.no>
In-Reply-To: <20131113112126.GA854@samfundet.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 07:21 PM, Hans-Christian Egtvedt wrote:
> Around Tue 12 Nov 2013 16:38:47 +0800 or thereabout, Chen Gang wrote:
>> For all uapi headers, need use "_UAPI" prefix for its guard macro
>> (which will be stripped by "scripts/headers_installer.sh").
>>
>> Also remove redundant files (bitsperlong.h, errno.h, fcntl.h, ioctl.h,
>> ioctls.h, ipcbuf.h, kvm_para.h, mman.h, poll.h, resource.h, siginfo.h,
>> statfs.h, and unistd.h) which are already in Kbuild.
>>
>> Also be sure that all "#endif" only have one empty line above, and each
>> file has guard macro.
> 
> Thank you for fixing and cleaning, but this current patch does not build after
> applying. The deleted files needs to be added in Kbuild to pick the generic
> header files instead.
> 

Oh, it is my fault, thanks. :-)

> Something ala
> diff --git a/arch/avr32/include/uapi/asm/Kbuild b/arch/avr32/include/uapi/asm/Kbuild
> index 3b85ead..08d8a3d 100644
> --- a/arch/avr32/include/uapi/asm/Kbuild
> +++ b/arch/avr32/include/uapi/asm/Kbuild
> @@ -2,35 +2,35 @@
>  include include/uapi/asm-generic/Kbuild.asm
>  
>  header-y += auxvec.h
> -header-y += bitsperlong.h
>  header-y += byteorder.h
>  header-y += cachectl.h
> -header-y += errno.h
> -header-y += fcntl.h
> -header-y += ioctl.h
> -header-y += ioctls.h
> -header-y += ipcbuf.h
> -header-y += kvm_para.h
> -header-y += mman.h
>  header-y += msgbuf.h
>  header-y += param.h
> -header-y += poll.h
>  header-y += posix_types.h
>  header-y += ptrace.h
> -header-y += resource.h
>  header-y += sembuf.h
>  header-y += setup.h
>  header-y += shmbuf.h
>  header-y += sigcontext.h
> -header-y += siginfo.h
>  header-y += signal.h
>  header-y += socket.h
>  header-y += sockios.h
>  header-y += stat.h
> -header-y += statfs.h
>  header-y += swab.h
>  header-y += termbits.h
>  header-y += termios.h
>  header-y += types.h
>  header-y += unistd.h
> +generic-y += bitsperlong.h
> +generic-y += errno.h
> +generic-y += fcntl.h
> +generic-y += ioctl.h
> +generic-y += ioctls.h
> +generic-y += ipcbuf.h
> +generic-y += kvm_para.h
> +generic-y += mman.h
>  generic-y += param.h
> +generic-y += poll.h
> +generic-y += resource.h
> +generic-y += siginfo.h
> +generic-y += statfs.h
> 

And I should check my original another architectures' 'same' patches for
'header-y' and 'generic-y'.


> I can amend this change, and add the patch to my for-linus branch.
> 
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> 

Thank you very much.

> 
> <snipp diff>
> 


Thanks.
-- 
Chen Gang
