Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3JAAQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 20:16:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49948 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3JAAQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 20:16:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <524A1440.6080106@roeck-us.net>
Date: Mon, 30 Sep 2013 17:16:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Brian Gitonga Marete <marete@toshnix.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Thomas Renninger <trenn@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: coretemp.ko not auto-loaded on 3.11.x
References: <CAHVUoiQiBDM5TQz_ptJw5HZad_SLA2+qV-6GSOCvYAo+QBZdow@mail.gmail.com> <CAHVUoiTvA6Eg49GvWM+eb4yQJymUKetMzC9Qm6S3U--5xz8rLA@mail.gmail.com>
In-Reply-To: <CAHVUoiTvA6Eg49GvWM+eb4yQJymUKetMzC9Qm6S3U--5xz8rLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 03:29 PM, Brian Gitonga Marete wrote:
> On Tue, Oct 1, 2013 at 12:25 AM, Brian Gitonga Marete
> <marete@toshnix.com> wrote:
>> Hello all,
>>
>> Some time ago, an enhancement was made to the kernel that caused
>> coretemp.ko (as well as other cpu-specific drivers) to be auto-loaded.
>>
>> This has broken for me in 3.11.x. It works fine on 3.10.x.
>>
>> Please see the attached kernel config and let me know if I left out
>> something notwithstanding doing a `sillentoldconfig' from my 3.10.x
>> config, which does not exhibit the problem.
>>
>
> Some further information which upon some research, may be useful:
>
> Kernel is 3.11.2 (But misbehavior first seen with 3.11.0)
>
> $ cat /sys/devices/system/cpu/modalias
> x86cpu:vendor:0000:family:0006:model:0025:feature:,0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,0015,0016,0017,0018,0019,001A,001B,001C,001D,001F,002B,0034,003B,003D,0068,006B,006C,006D,006F,0070,0072,0074,0075,0076,0078,007C,0080,0082,0083,0084,0085,0087,0088,0089,008D,008E,008F,0091,0093,0094,0097,00C0,00E0,00E1,00E7,0100,0101,0102,0103,0104
>
> $ modinfo coretemp
> filename:       /lib/modules/3.11.2/kernel/drivers/hwmon/coretemp.ko
> license:        GPL
> description:    Intel Core temperature monitor
> author:         Rudolf Marek <r.marek@assembler.cz>
> srcversion:     31B63A96FD9FD13CDDBDF32
> alias:          x86cpu:vendor:0000:family:*:model:*:feature:*00E7*
> depends:
> intree:         Y
> vermagic:       3.11.2 SMP mod_unload modversions
> parm:           tjmax:TjMax value in degrees Celsius (int)
>
> I have UDEV 175 from Ubuntu 12.04.
>
> The module alias seems to match that in cat
> /sys/devices/system/cpu/modalias, so udev should be able to probe for
> and load coretemp.ko, but that is not happening, which is strange to
> me.
>
> I also note that microcode.ko, which is handled by the same mechanism
> for auto-loading based on CPUID, is no longer auto-loaded in kernel
> 3.11.x.
>
> I have added Thomas Renninger and Greg Kroah-Hartman to the thread CC.
>

See

http://lists.lm-sensors.org/pipermail/lm-sensors/2013-August/039745.html

and

http://lists.opensuse.org/opensuse-bugs/2013-08/msg01676.html

as well as

http://cgit.freedesktop.org/systemd/systemd/commit?id=bf7f800f2b3e93ccd1229d4717166f3a4d3af72f

In summary, you'll need a new udev rule.

Guenter

