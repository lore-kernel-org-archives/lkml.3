Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbaKTUvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:51:22 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52750 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:51:18 -0500
MIME-Version: 1.0
In-Reply-To: <20141120203749.GM108701@redhat.com>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
	<20141118145234.GA7487@redhat.com>
	<alpine.DEB.2.11.1411181914020.3909@nanos>
	<20141118215540.GD35311@redhat.com>
	<20141119021902.GA14216@redhat.com>
	<CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
	<20141119145902.GA13387@redhat.com>
	<546D0530.8040800@mit.edu>
	<20141120152509.GA5412@redhat.com>
	<CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
	<20141120203749.GM108701@redhat.com>
Date: Thu, 20 Nov 2014 12:51:17 -0800
X-Google-Sender-Auth: O8973FfbAPfBcQR_5Gc9OJTLA-k
Message-ID: <CA+55aFzB3wfHgd6zwG0V0REvncqqubmFxV3Xzme4gL_Eecra_A@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 12:37 PM, Don Zickus <dzickus@redhat.com> wrote:
>
> Just for clarification, softlockups are processes hogging the cpu (thus
> blocking the high priority per-cpu watchdog thread).

Right. And there is no actual sign of any CPU hogging going on.
There's a single system call with a small payload (I think it's safe
to call 64kB small these days), no hugely contended CPU-spinning
locking, nada.

                    Linus
