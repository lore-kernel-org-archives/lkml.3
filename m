Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3BLDdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 22:33:24 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:55908 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3BLDdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 22:33:23 -0500
MIME-Version: 1.0
In-Reply-To: <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
References: <20130209110031.GA17833@n2100.arm.linux.org.uk> <tip-b390784dc1649f6e6c5e66e5f53c21e715ccf39b@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Feb 2013 19:33:02 -0800
X-Google-Sender-Auth: sSSe0oa2vqHXzBtpljeNzDAKUdg
Message-ID: <CA+55aFxaUUMQuw3bgLbZLARp05eM19E_qTXBYePPk9mvEsSp=g@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Use a bitfield to mask nuisance get_user() warnings
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ville.syrjala@linux.intel.com, Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 5:37 PM, tip-bot for H. Peter Anvin
<hpa@zytor.com> wrote:
>
> However, we can declare a bitfield using sizeof(), which is legal
> because sizeof() is a constant expression.  This quiets the warning,
> although the code generated isn't 100% identical from the baseline
> before 96477b4 x86-32: Add support for 64bit get_user():

Christ. This is so ugly that it's almost a work of art.

Has anybody run this past any gcc developers? And if so, did they run
away screaming?

                 Linus
