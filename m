Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab3B1DTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 22:19:33 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38026 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3B1DT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 22:19:29 -0500
MIME-Version: 1.0
In-Reply-To: <512EC7F0.60103@redhat.com>
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
Date: Wed, 27 Feb 2013 19:19:28 -0800
X-Google-Sender-Auth: 6tQ9Hyeihv82a-UB_42eL78b2sM
Message-ID: <CA+55aFxHco9QKkzJshbae4athxGdCoZY0vBB3Y=mJ6deOLnJuQ@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Wed, Feb 27, 2013 at 6:58 PM, Rik van Riel <riel@redhat.com> wrote:
>
> On the other hand, both MCS and the fast queue locks
> implemented by Michel showed low variability and high
> performance.

On microbenchmarks, and when implemented for only one single subsystem, yes.

> The numbers for Michel's MCS and fast queue lock
> implementations appear to be both fast and stable.

I do think that doing specialized spinlocks for special areas may be a
rasonable approach, and it's quite possible that the SySV IPC thing is
one such area.

But no, I don't think the numbers I've seen for Michel's MCS are AT
ALL comparable to the generic spinlocks, and the interface makes them
incompatible as a replacement to even test in general.

Don't get me wrong: I think the targeted approach is *better*. I just
also happen to think that you spout big words about things that aren't
all that big, and try to make this a bigger deal than it is. The
benchmark numbers you point to are micro-benchmarks, and not all
comparable.

              Linus
