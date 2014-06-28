Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaF1MxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:53:24 -0400
Received: from orange.myspectrum.nl ([149.210.134.247]:42005 "EHLO
	orange.myspectrum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaF1MxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:53:08 -0400
Message-ID: <53AEBAAF.6020400@myspectrum.nl>
Date: Sat, 28 Jun 2014 14:53:03 +0200
From: Jeroen Hofstee <jeroen@myspectrum.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Jeroen Hofstee <jeroen@myspectrum.nl>
CC: u-boot@lists.denx.de, linux-kernel@vger.kernel.org
Subject: Re: [U-Boot] [RFC] kbuild.h: workaround for llvm IAS
References: <20140624215349.3E89.AA925319@jp.panasonic.com>	<53A9D326.9060409@myspectrum.nl> <20140627153815.7B85.AA925319@jp.panasonic.com>
In-Reply-To: <20140627153815.7B85.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Masahiro,

On 27-06-14 08:38, Masahiro Yamada wrote:
> KBuild (ab)uses the asm statement to write to a file and
> llvm integrated as chokes about these invalid asm statements.
> Workaround it by making it look like valid asm code.
>
> Signed-off-by: Jeroen Hofstee <jeroen@myspectrum.nl>
>>> I think Linux has the same problem.
>>>
>>> Are you willing to this patch to linux-kbuild ML?
>>> Or fixing U-Boot only?
>> I don't mind in general, but it is just noise for them (cc-ing them to
>> create some).  For u-boot (ARM) you actually get a valid binary with
>> this patch after clang support has landed, for linux you just get other
>> errors as far as I tried (native only), patch below.
>>
>> However in linux there seem more spots relying on the format, e.g.
>>       arch/ia64/kvm/Makefile
>>       arch/ia64/kernel/Makefile
>>       arch/um/Makefile
>>
>> So if anything, I think this should be made a general rules first
>> in the makefiles. It seems stupid to potentially break something
>> while it gains nothing.
>>
>> So yes, u-boot only afaic, or does that make your syncing more difficult?
> I don't think syncing would be difficult.
>
> BTW, do you know how they resolve this build error in other projects,
> for example, in llvmlinux ?
> http://llvm.linuxfoundation.org/index.php/Main_Page
>
> Linux folks merged Clang support into the top Makefile, but not into ./Kbuild.
> I don't know why.
I don't know how the llvmlinux people do it, but the alternative is to
add -no-integrated-as for clang when compiling such files (or use an
older clang version, since that used to be the default). Since gcc's LTO
dislikes the asm-offset.c technique as well, I think it is better to 
actually
create valid asm, so it no longer depends on compiler features at all.
I will leave it up to the llvmlinux folks to come up with a solution for
linux though...

Regards,
Jeroen





