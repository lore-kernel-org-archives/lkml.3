Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaKYRWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:22:09 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:52629 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKYRWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:22:07 -0500
MIME-Version: 1.0
In-Reply-To: <54741540.3010607@suse.com>
References: <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
	<CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
	<CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
	<20141121142301.564f7eb7@gandalf.local.home>
	<CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
	<CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
	<CALCETrX9CNx+Zs3timzxoccrqia1RiaOe5dj7crENnt2W6PGjg@mail.gmail.com>
	<CA+5PVA4mgpAg53bQKnXXgY3N0mkEZrUYf4rgOTHCV-pbK9UF3g@mail.gmail.com>
	<CALCETrUT3Pn0ZCMsgp9dyDvoaiszCrQRc4159Tyggo5wA6Mp7w@mail.gmail.com>
	<CA+5PVA5L1Vcs+nrJWZ+jXgnhQMZ_L22rksopPnO7Wt04jD3kUQ@mail.gmail.com>
	<20141124184856.GA9349@laptop.dumpdata.com>
	<54741540.3010607@suse.com>
Date: Tue, 25 Nov 2014 09:22:04 -0800
X-Google-Sender-Auth: EctTo7rD9xU8-uCN1GfzwtoE3AY
Message-ID: <CA+55aFxSRujj=cM1NkXYvxmo=Y1hb1e3tgLhdh1JDphzV6WKRw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 9:36 PM, Jürgen Groß <jgross@suse.com> wrote:
>
> Funny, during testing some patches related to Xen I hit the lockup
> issue. It looked a little bit different, but a variation of your patch
> solved my problem.
>
> I could reproduce the issue within a few minutes reliably without the
> patch below. With it the machine survived 12 hours and is still running.

Do you have a backtrace for the failure case? I have no problem
applying this part of the patch (I really don't understand why x86-64
hadn't gotten the proper code from 32-bit), but I'd like to see (and
document) where the fault happens for this.

Since you can apparently reproduce this fairly easily with a broken
kernel, getting a backtrace shouldn't be too hard?

                     Linus
