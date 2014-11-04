Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaKDOpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:45:01 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58753 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbaKDOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:44:48 -0500
MIME-Version: 1.0
In-Reply-To: <87fvesedfd.fsf@rustcorp.com.au>
References: <CAPM=9tyLrJ8VAdGCw_1guRS-ogCPE1Qp7faE_nrx_dAm2gvHLQ@mail.gmail.com>
	<87vc65p5a7.fsf@rustcorp.com.au>
	<CAPM=9tzw8jEv8yoLr7ktjO2DHCDzA+mURmJ-DXby_nsWUUNoyg@mail.gmail.com>
	<87li71oucu.fsf@rustcorp.com.au>
	<CAAts5mM_+Mj=vjWyJc8wZCvZehfK5dZxeA0Y9eowHwFDiWxo9Q@mail.gmail.com>
	<87fvesedfd.fsf@rustcorp.com.au>
Date: Tue, 4 Nov 2014 15:44:47 +0100
X-Google-Sender-Auth: lr9klhstR32DURh-qyqsT-d77Ug
Message-ID: <CAAts5mPGV+u+r5cr4Ry+ePOpJSDY0BKY_T4A+hPaXVTWXL=TDg@mail.gmail.com>
Subject: Re: BUG_ON in virtio-ring.c
From: Alexey Lapitsky <lex.public@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the long delay. It prints exactly the same:

[    3.792033] virtqueue elements = 128, max_segments = 126 (1 queues)
[    3.802191]  vda: vda1 vda2 < vda5 >

A little bit more about my setup (if it helps):

It's a qemu-system-x86_64 kvm instance with 16 cores and 10G of RAM.
I can reproduce the bug every time with mkfs.btrfs on a 10GB LVM
volume (right after the reboot).

I have almost no knowledge of vring / virtio.
Is it correct that we need just one sg_elem entry in the vq->vring if
vq->indirect flag is set?
That's what I thought when applying the "BUG_ON(total_sg >
vq->vring.num && !vq->indirect)" patch.
