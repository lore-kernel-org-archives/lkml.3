Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3GKCdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:33:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63331 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3GKCc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:32:59 -0400
Message-ID: <51DE193E.7060700@windriver.com>
Date: Thu, 11 Jul 2013 10:32:30 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>
CC: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, <kexec@lists.infradead.org>
Subject: Re: BUG: 32 Bit Kernel kexec hangs on P2020
References: <1373445543.348.5.camel@wall-e> <51DD1FC7.6080203@windriver.com> <1373450412.1016.3.camel@wall-e>
In-Reply-To: <1373450412.1016.3.camel@wall-e>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.214]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 06:00 PM, Stefani Seibold wrote:
> Am Mittwoch, den 10.07.2013, 16:48 +0800 schrieb tiejun.chen:
>> On 07/10/2013 04:39 PM, Stefani Seibold wrote:
>>> Hi,
>>>
>>> i have tried to kexec a 32 bit kernel on a Freescale P2020 dual core CPU
>>> (e500v2, revison 5.1 - pvr 8021 1051), but Kexec will hang after the
>>> "Bye!".
>>>
>>> The host and the kexec kernel are the same, based on the current kernel
>>> version 3.10.
>>>
>>> I have tried it with kexec-tools 2.0.4.git released 30 June 2013.
>>>
>>> Invoking kexec with
>>>
>>> kexec --command-line "1 maxcpus=1 noirqdistrib reset_devices $(cat /proc/cmdline)" -t elf-ppc --dtb=rs2020.dtb \
>>> --reuse-node="/cpus/PowerPC,P2020@0/timebase-frequency" \
>>> --reuse-node="/cpus/PowerPC,P2020@0/bus-frequency" \
>>> --reuse-node="/cpus/PowerPC,P2020@0/clock-frequency" \
>>> --reuse-node="/cpus/PowerPC,P2020@0/next-level-cache" \
>>> --reuse-node="/cpus/PowerPC,P2020@1/timebase-frequency" \
>>> --reuse-node="/cpus/PowerPC,P2020@1/bus-frequency" \
>>> --reuse-node="/cpus/PowerPC,P2020@1/clock-frequency" \
>>> --reuse-node="/cpus/PowerPC,P2020@1/next-level-cache" \
>>> --reuse-node="/cpus/PowerPC,P2020@1/cpu-release-addr" \
>>> --reuse-node="/cpus/PowerPC,P2020@1/enable-method" \
>>> --reuse-node="/soc@ffe00000/bus-frequency" \
>>> --reuse-node="/soc@ffe00000/serial@4500/clock-frequency" \
>>> --reuse-node="/soc@ffe00000/ethernet@24000/local-mac-address" \
>>> -d -l -x vmlinux
>>> kexec -e
>>
>> Could you try again with one simple command like,
>>
>> kexec -l vmlinux --append="`cat /proc/cmdline`";kexec -e
>>
>
> Great, this works.
>
> I did more test and the issue for the fail is the passing of the device
> tree. But the device tree is exact the same as the previous used one.
>
> Is passing a new device tree not allowed?

No, I think this is not interdicted.

I suspect you probably don't pass a proper dtb, so you can take a further test 
to figure out this problem.

For example, in the u-boot prompt, you can use the fdt command to get last dtb 
after that board setup from u-boot, then pass that directly to try.

Tiejun

