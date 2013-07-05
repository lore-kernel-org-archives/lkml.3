Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3GET1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:27:53 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:45828 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3GET1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:27:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130705065113.GA6588@gmail.com>
References: <20130704015525.GA8486@redhat.com>
	<CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
	<51D5BA25.9060207@zytor.com>
	<20130705065113.GA6588@gmail.com>
Date: Fri, 5 Jul 2013 12:27:51 -0700
X-Google-Sender-Auth: ySGBVVHsY6383b5IiQR_MLYNias
Message-ID: <CA+55aFx57XS4wYeEmukk8hMGxD4sVu0pz_BYppEeOdScJObXxw@mail.gmail.com>
Subject: Re: scheduling while atomic & hang.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 11:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> It would be nice to have a full-kernel-stack backtrace printout as an
> option, which prints entries 'above' the current RSP.

One problem with that is that it is likely to be mostly overwritten by
the debug code that is about to print this all out - and any non-debug
code may well be really old, just with a sufficiently deep stack trace
to show up. Not to mention missing any irq-stack changes etc anyway.

So it can easily be *very* misleading - I'm not sure how useful it
would be as an idea.

                Linus
