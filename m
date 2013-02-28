Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab3B1U0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:26:18 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:49398 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3B1U0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:26:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	<tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
	<CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
	<511BE4A3.8050607@redhat.com>
	<CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
	<511C1204.9040608@redhat.com>
	<CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
	<511C24A6.8020409@redhat.com>
	<CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
	<512E376D.70105@redhat.com>
	<CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
	<512E6443.9050603@redhat.com>
	<CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com>
	<512E80E3.7060800@redhat.com>
	<CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
	<512EC7F0.60103@redhat.com>
	<1362024397.1867.28.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com>
	<512F7429.4020103@redhat.com>
	<CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
Date: Thu, 28 Feb 2013 12:26:14 -0800
X-Google-Sender-Auth: HabozS_A4_PJWD-pZJU2iQPGOEU
Message-ID: <CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:22 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'm sure there are other things we could do to improve ipc lock times
> even if we don't actually split the lock, but the security one might
> be a good first step.

Btw, if somebody has a benchmark for threads using multiple ipc
semaphores (from the same semget() allocation) concurrently, and we
could have a simple way to see the contention without having to run
some big DB thing, that would also be nice. Maybe there is something
out there already? Google didn't find any, and the normal benchmarks
I'm aware of all just do one single (private) ipc semaphore per
process.

Nothing gets some people going like just having a nice benchmark to
show the effect.

Because maybe I'm wrong, and there really are people who would love to
muck around with the SysV IPC code, and they just didn't have the
right reason or benchmark for it...

                Linus
