Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaEBSjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbaEBSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:39:21 -0400
From: Bandan Das <bsd@redhat.com>
To: Hu Yaohui <loki2441@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: KVM Nested L2 guest startup problems
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
	<53636B1D.8030405@redhat.com>
	<CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
	<5363BF42.9020505@redhat.com>
	<CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>
Date: Fri, 02 May 2014 14:39:18 -0400
In-Reply-To: <CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>
	(Hu Yaohui's message of "Fri, 2 May 2014 13:07:16 -0400")
Message-ID: <jpgzjj0xbxl.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hu Yaohui <loki2441@gmail.com> writes:

> On Fri, May 2, 2014 at 11:52 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Il 02/05/2014 17:17, Hu Yaohui ha scritto:
>>
>>> Hi Paolo,
>>> I have tried L0 with linux kernel 3.14.2 and L1 with linux kernel 3.14.2
>>> L1 QEMU qemu-1.7.0
>>> L2 QEMU qemu-1.7.0.
>>
>>
>> Do you mean L0 and L1?
> Yes.
>>
>> What is your QEMU command line, and what is the processor?  Also, what guest
>> you are running?
>>
> L0 host
> - Debian 7 with linux kernel 3.14.2
> - 24 pCPU, 120G pMEM
> - cpu mode: Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz

Ivy Bridge-EP ? Looks similar to 
https://bugzilla.kernel.org/show_bug.cgi?id=73331

Just out of curiosity, any difference if you run with ept=0 ?

> - QEMU command line of L1
> $ sudo qemu-system-x86_64 -machine accel=kvm -drive
> file=vdisk.img,if=virtio -m 4096 -smp 10 -net
> nic,model=virtio,macaddr=52:54:00:12:34:80 -cpu kvm64,+vmx -net
> tap,ifname=qtap0,script=no,downscript=no -vnc :2
>
> L1 guest
> - Ubuntu 10.04 with linux kernel 3.14.2
> - QEMU command line of L2
> $qemu-system-x86_64  -machine accel=kvm -smp 2 -boot c -drive
> file=/home/nested/vmdisks/vdisk1-virtnet.img,if=virtio -m 2048 -vnc :4
> -net nic,model=virtio,macaddr=52:54:00:12:34:90 -net
> tap,ifname=qtap0,script=no,downscript=no
>
> L2 guest
> - Ubuntu 10.04 with linux kernel 2.6.32
>> Paolo
>>
>>
>>> I still get the same error when running qemu in L1 guest.
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
