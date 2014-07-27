Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaG0Uhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 16:37:37 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:52664 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaG0Uhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 16:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
	<20140727083758.GA4834@fancy-poultry.org>
	<CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
Date: Sun, 27 Jul 2014 16:37:35 -0400
Message-ID: <CAPDOMVgFC4J6N2OU3_gX=ak=U=4kqYGoZaKSHYORkS5z9QDwDw@mail.gmail.com>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
From: Nick Krause <xerofoify@gmail.com>
To: htd@fritha.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 4:18 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Sun, Jul 27, 2014 at 4:37 AM, Heinz Diehl <htd@fancy-poultry.org> wrote:
>> On 27.07.2014, Nick Krause wrote:
>>
>>> When I transfer a lot of music for a brtfs external hard drive I have the music
>>> in clementine I am listening to is stopped for a few seconds and then continues.
>>
>> Most probably, this is not a bug, but caused by high disk I/O. It's
>> not clear to me if the music you are listening to is located on the
>> same disk which you transfer to/from. This would make things even
>> worse.
>>
>> However, there are a few thing you can do to try to minimize the observed
>> stalls:
>>
>> 1. Compile your kernel with CONFIG_PREEMPT enabled
>> 2. Reduce the amount of memory content sync'ed to disk
>> 3. If your disk is a SSD: change the elevator to "noop"
>> 4. Enable writeback on your disk
>> 5. Increase the disks readahead sectors
>> 6. Increase the audio buffers in your player
>>
>> 1. CONFIG_PREEMPT=y
>>
>> 2. Sysctl: vm.dirty_ratio = 10
>>            vm.dirty_background_ratio = 5
>>
>> 3. echo "noop" > /sys/block/sda/queue/scheduler
>>
>> 4. /sbin/hdparm -W1 /dev/sda
>>
>> 5. /sbin/blockdev --setra 8192 /dev/sda
>>
>> Regards,
>>  Heinz.
> Heinz,
> The audio buffer is not going to work as this was never a issue with
> default Ubuntu kernels.
> However I will try your other ideas and report back :). I am
> transferring into the same directory
> for the music I am listening to. In addition , my cpu usage when doing
> this is half of my older
> Ubuntu distro kernel, 6 vs 3 percent for upstream.
> Cheers Nick

Seems to be an issue after updating my settings as stated.
I am now using kernel 3.16 r7 as I updated my git tree before
compiling my kernel again.
Regards Nick
