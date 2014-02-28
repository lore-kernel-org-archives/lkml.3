Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaB1UT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:19:56 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:39746 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaB1UTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:19:54 -0500
MIME-Version: 1.0
In-Reply-To: <e33a0c21-5d74-4584-ac35-8cd45a905310@email.android.com>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
 <cover.1393545985.git.luto@amacapital.net> <2f5d45b67dcd2c4ba58ed7ff13cfcd7a4da977fa.1393545985.git.luto@amacapital.net>
 <1393572505.1019.10.camel@wall-e.seibold.net> <e33a0c21-5d74-4584-ac35-8cd45a905310@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 28 Feb 2014 12:19:34 -0800
Message-ID: <CALCETrXOrJPidKSAshwE94wumnWqZdwDQ0+fWAY8UZxLf+PCdw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] x86: Use the default ABI for the 32-bit vDSO
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 7:06 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> How many internal function calls are there? It seems we should try to avoid those as much as possible by suitable inlining.

There are no non-static calls at all, except for __x86.get_pc_thunk.
I imagine that gcc is smart enough to improve the calling convention
to non-externally-visible functions.

Amazingly (to me, anyway), the performance of the 32-bit version seems
to be within 1 ns or so of the 64-bit version on SNB.  I suspect that
Intel has optimized the crap out of these things.

--Andy
