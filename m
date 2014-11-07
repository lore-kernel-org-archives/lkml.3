Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaKGJk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:40:27 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56897 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaKGJkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:40:24 -0500
MIME-Version: 1.0
In-Reply-To: <1415352966.14686.101.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	<CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
	<20141107073720.GB24745@yliu-dev.sh.intel.com>
	<CAKv+Gu-rRMmcP4LF3oo5=6hf8m7fjzkzV14hfkjBPbPn34OZGA@mail.gmail.com>
	<20141107081344.GC24745@yliu-dev.sh.intel.com>
	<CAKv+Gu9u5ojSWarm2A5MeWOj1r1+W8U0d+icnx2rfAmiSaL8Ww@mail.gmail.com>
	<20141107084604.GD24745@yliu-dev.sh.intel.com>
	<CAKv+Gu_Xx9aKzNU2CfP20WR1ojwjUEvTKyD7L-S9bR_C8EOogQ@mail.gmail.com>
	<20141107092651.GE24745@yliu-dev.sh.intel.com>
	<1415352966.14686.101.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Fri, 7 Nov 2014 10:40:22 +0100
Message-ID: <CAKv+Gu_YzZUqZBGAb+U8MGEfUQ8-yyCPj=QMeEbamKxSi8Wb5A@mail.gmail.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, LKP <lkp@01.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 10:36, Matt Fleming <matt.fleming@intel.com> wrote:
> On Fri, 2014-11-07 at 17:26 +0800, Yuanhan Liu wrote:
>>
>> Here is the output:
>>
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] ====== Decoding _DMI_ header:
>> [    0.000000] 5f 44 4d 49 5f 48 a3 0b 00 20 60 8f 3e 00 25 00
>> [    0.000000] ====== Remapped SMBIOS table 0xffffffff8f602000 at ffffffffff240000, size 0xba3, num 0x3e
>
> Smells like a sign extension issue. Previously how could dmi_base (u32)
> hold 0xffffffff8f602000?
>

Exactly. And note that we already found (and fixed, or so we thought)
this issue.

I.e, on the ARM you get

>>> ====== Remapped SMBIOS table 0xfe8ac000 at ffffff800001e000, size 0x262, num 0xc

which has the top bit set as well, but is handled correctly, whereas
with the original code (i.e., before adding the get_unaligned_le32()),
we were hitting the same problem.

-- 
Ard.
