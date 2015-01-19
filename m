Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbbASEA0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:00:26 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42908 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASEAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:00:24 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
	<tip-7e9358073d3f0ed0a028c48aa54009b3296dffc9@git.kernel.org>
	<CA+55aFyc7TbnLBi3rcQDrtkwg9TgDnb5dAfupMGSbTKZC6Xd0g@mail.gmail.com>
Date: Mon, 19 Jan 2015 16:00:23 +1200
X-Google-Sender-Auth: O_mFMBpSzbqT39SmQGWjV3eO6vw
Message-ID: <CA+55aFycO_d0oO9rw9fXa13NSNc0Am8v+3rV+eSH9YdsCi-2Mg@mail.gmail.com>
Subject: Re: [tip:core/types] bitops: Add sign_extend8(), 16 and 64 functions
From: Linus Torvalds <torvalds@linux-foundation.org>
To: jsrhbz@kanargh.force9.co.uk, christoph.muellner@theobroma-systems.com,
        Guenter Roeck <linux@roeck-us.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, martink@posteo.de,
        "Theodore Ts'o" <tytso@mit.edu>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 7:54 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The 8- and 16- bit versions are the same as the 32-bit one.

Side note: the 64-bit one is actually different on 32-bit
architectures, not because it would generate a different value, but
because the 64-bit overhead likely kills you. It might be that the
compiler is smart enough that we'd *only* need the 64-bit version, but
for non-constant bit numbers, it's likely hard for gcc to generate
sane single-register versions, and so the 64-bit version is likely
fine.

But I don't see the 8-bit and 16-bit versions generating better code
on any sane architecture.

           Linus
