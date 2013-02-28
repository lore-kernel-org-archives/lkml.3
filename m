Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3B1EtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:49:08 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:38826 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B1EtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:49:03 -0500
MIME-Version: 1.0
In-Reply-To: <1362024397.1867.28.camel@buesod1.americas.hpqcorp.net>
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
Date: Wed, 27 Feb 2013 20:49:01 -0800
X-Google-Sender-Auth: Bn8_qE34ilnK21zjikNRKA6r1PU
Message-ID: <CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>,
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

On Wed, Feb 27, 2013 at 8:06 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> The attached file shows how the amount of sys time used by the ipc lock
> for a 4 and 8 socket box.

I have to say, even with the improvements, that looks pretty
disgusting. It really makes me wonder if that thing couldn't be done
better some way. Is it the SysV semaphores that this all ends up
using, or what?

That said, I think the IPC layer is just about the perfect candidate
for things like this, because I'm afraid that nobody is ever going to
fix it.

          Linus
