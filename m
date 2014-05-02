Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaEBULZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:11:25 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53680 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaEBULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <jpgzjj0xbxl.fsf@nelium.bos.redhat.com>
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
	<53636B1D.8030405@redhat.com>
	<CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
	<5363BF42.9020505@redhat.com>
	<CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>
	<jpgzjj0xbxl.fsf@nelium.bos.redhat.com>
Date: Fri, 2 May 2014 16:11:22 -0400
Message-ID: <CAHqbYQuaaUaGTahryghh0nX99msMgeNQr=yv34mbgDJbFeSCbw@mail.gmail.com>
Subject: Re: KVM Nested L2 guest startup problems
From: Hu Yaohui <loki2441@gmail.com>
To: Bandan Das <bsd@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 2:39 PM, Bandan Das <bsd@redhat.com> wrote:
> Hu Yaohui <loki2441@gmail.com> writes:
>
>> On Fri, May 2, 2014 at 11:52 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> Il 02/05/2014 17:17, Hu Yaohui ha scritto:
>>>
>>>> Hi Paolo,
>>>> I have tried L0 with linux kernel 3.14.2 and L1 with linux kernel 3.14.2
>>>> L1 QEMU qemu-1.7.0
>>>> L2 QEMU qemu-1.7.0.
>>>
>>>
>>> Do you mean L0 and L1?
>> Yes.
>>>
>>> What is your QEMU command line, and what is the processor?  Also, what guest
>>> you are running?
>>>
>> L0 host
>> - Debian 7 with linux kernel 3.14.2
>> - 24 pCPU, 120G pMEM
>> - cpu mode: Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz
>
> Ivy Bridge-EP ? Looks similar to
> https://bugzilla.kernel.org/show_bug.cgi?id=73331
>
> Just out of curiosity, any difference if you run with ept=0 ?
I have tried it. The same error with L0 kvm ept=1 and L1 kvm ept=0
Do you have any idea how the Ivy Bridge-EP problem is solved?
>
>> - QEMU command line of L1
>> $ sudo qemu-system-x86_64 -machine accel=kvm -drive
>> file=vdisk.img,if=virtio -m 4096 -smp 10 -net
>> nic,model=virtio,macaddr=52:54:00:12:34:80 -cpu kvm64,+vmx -net
>> tap,ifname=qtap0,script=no,downscript=no -vnc :2
>>
>> L1 guest
>> - Ubuntu 10.04 with linux kernel 3.14.2
>> - QEMU command line of L2
>> $qemu-system-x86_64  -machine accel=kvm -smp 2 -boot c -drive
>> file=/home/nested/vmdisks/vdisk1-virtnet.img,if=virtio -m 2048 -vnc :4
>> -net nic,model=virtio,macaddr=52:54:00:12:34:90 -net
>> tap,ifname=qtap0,script=no,downscript=no
>>
>> L2 guest
>> - Ubuntu 10.04 with linux kernel 2.6.32
>>> Paolo
>>>
>>>
>>>> I still get the same error when running qemu in L1 guest.
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
