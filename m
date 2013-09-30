Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3I3WaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:30:12 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39931 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3I3WaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:30:10 -0400
MIME-Version: 1.0
X-Originating-IP: [212.49.88.104]
In-Reply-To: <CAHVUoiQiBDM5TQz_ptJw5HZad_SLA2+qV-6GSOCvYAo+QBZdow@mail.gmail.com>
References: <CAHVUoiQiBDM5TQz_ptJw5HZad_SLA2+qV-6GSOCvYAo+QBZdow@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Tue, 1 Oct 2013 01:29:50 +0300
Message-ID: <CAHVUoiTvA6Eg49GvWM+eb4yQJymUKetMzC9Qm6S3U--5xz8rLA@mail.gmail.com>
Subject: Re: coretemp.ko not auto-loaded on 3.11.x
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 12:25 AM, Brian Gitonga Marete
<marete@toshnix.com> wrote:
> Hello all,
>
> Some time ago, an enhancement was made to the kernel that caused
> coretemp.ko (as well as other cpu-specific drivers) to be auto-loaded.
>
> This has broken for me in 3.11.x. It works fine on 3.10.x.
>
> Please see the attached kernel config and let me know if I left out
> something notwithstanding doing a `sillentoldconfig' from my 3.10.x
> config, which does not exhibit the problem.
>

Some further information which upon some research, may be useful:

Kernel is 3.11.2 (But misbehavior first seen with 3.11.0)

$ cat /sys/devices/system/cpu/modalias
x86cpu:vendor:0000:family:0006:model:0025:feature:,0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,0015,0016,0017,0018,0019,001A,001B,001C,001D,001F,002B,0034,003B,003D,0068,006B,006C,006D,006F,0070,0072,0074,0075,0076,0078,007C,0080,0082,0083,0084,0085,0087,0088,0089,008D,008E,008F,0091,0093,0094,0097,00C0,00E0,00E1,00E7,0100,0101,0102,0103,0104

$ modinfo coretemp
filename:       /lib/modules/3.11.2/kernel/drivers/hwmon/coretemp.ko
license:        GPL
description:    Intel Core temperature monitor
author:         Rudolf Marek <r.marek@assembler.cz>
srcversion:     31B63A96FD9FD13CDDBDF32
alias:          x86cpu:vendor:0000:family:*:model:*:feature:*00E7*
depends:
intree:         Y
vermagic:       3.11.2 SMP mod_unload modversions
parm:           tjmax:TjMax value in degrees Celsius (int)

I have UDEV 175 from Ubuntu 12.04.

The module alias seems to match that in cat
/sys/devices/system/cpu/modalias, so udev should be able to probe for
and load coretemp.ko, but that is not happening, which is strange to
me.

I also note that microcode.ko, which is handled by the same mechanism
for auto-loading based on CPUID, is no longer auto-loaded in kernel
3.11.x.

I have added Thomas Renninger and Greg Kroah-Hartman to the thread CC.

Thanks.

BGM.
