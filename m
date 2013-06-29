Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3F2VIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 17:08:13 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34001 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3F2VII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy8XfmbhaEFUvy5ToLuSSxw5dhw5vXbJ28QpA0sBZgYoQ@mail.gmail.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
 <CA+QCeVR=+2vpFdW_LcjZUdNd+udY4dZEWXxevONTnbs8Y6oECQ@mail.gmail.com> <CA+55aFy8XfmbhaEFUvy5ToLuSSxw5dhw5vXbJ28QpA0sBZgYoQ@mail.gmail.com>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Sun, 30 Jun 2013 00:07:46 +0300
Message-ID: <CA+QCeVTOQks+s7YEK1Sd-aKdg2ce=Jxchb5ATqW0fiZVebFMBw@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 29 June 2013 21:11, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Jun 29, 2013 at 8:05 AM, Sergey Meirovich <rathamahata@gmail.com> wrote:
>>
>> 3.10-rc7 doesn't compile for me
>>
>> rathamahata@piledriver /usr/local/src/linux-3.10-rc7 $ make -j1 bzImage modules
>> make[1]: Nothing to be done for `all'.
>> make[1]: Nothing to be done for `relocs'.
>>   CHK     include/generated/uapi/linux/version.h
>>   CHK     include/generated/utsrelease.h
>>   CALL    scripts/checksyscalls.sh
>>   CC      scripts/mod/devicetable-offsets.s
>>   GEN     scripts/mod/devicetable-offsets.h
>>   HOSTCC  scripts/mod/file2alias.o
>>   HOSTLD  scripts/mod/modpost
>>   CHK     include/generated/compile.h
>> make[3]: `arch/x86/realmode/rm/realmode.bin' is up to date.
>>   CC      drivers/gpu/drm/radeon/r200.o
>> drivers/gpu/drm/radeon/r200.c: In function ‘r200_set_safe_registers’:
>> drivers/gpu/drm/radeon/r200.c:546:34: error: ‘r200_reg_safe_bm’
>> undeclared (first use in this function)
>>   rdev->config.r100.reg_safe_bm = r200_reg_safe_bm;
>>                                   ^
>> drivers/gpu/drm/radeon/r200.c:546:34: note: each undeclared identifier
>
> Hmm. Your config builds here fine.
>
> What does your
>
>    drivers/gpu/drm/radeon/r200_reg_safe.h
>
> file look like?

This file is empty:
rathamahata@piledriver /usr/local/src/linux-3.10-rc7 $ cat
drivers/gpu/drm/radeon/r200_reg_safe.h
rathamahata@piledriver /usr/local/src/linux-3.10-rc7 $

> It's a generated file, and it sounds like it got
> mis-generated. There is possibly a broken Makefile rule that leaves it
> empty on errors or ^C: the rule is
>
>   quiet_cmd_mkregtable = MKREGTABLE $@
>         cmd_mkregtable = $(obj)/mkregtable $< > $@
>
> and if the 'mkregtable' binary is buggered, the above will leave an
> empty file around. And maybe your mkregtable failed to build earlier,
> leaving that empty file around and it will never fix itself up because
> of the "up-to-date" empty r200_reg_safe.h file.
>
> So removing the generated r200_reg_safe.h file

Removing just it doesn't change a lot.

> (and possibly the
> mkregtable binary) and trying again might fix it.

Removing mkregtable  has indeed the compile issue for me. Thanks!

> Which still leaves
> us with the question of how this happened, and a potentially fragile
> Makefile.
>
>                 Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
