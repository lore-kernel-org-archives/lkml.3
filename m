Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab3ANW2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:28:31 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60726 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab3ANW2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <1357134014-31203-1-git-send-email-linus.walleij@stericsson.com>
References: <1357134014-31203-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 14 Jan 2013 23:28:29 +0100
Message-ID: <CACRpkdZhzSbf4rNf57MFcZZraUfZ0xiJxs2TzPHQaYz4x4X10Q@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: tc3589x: use simple irqdomain
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        stable@kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 2:40 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> This fixes a regression in the TC3589x driver introduced in
> commit 15e27b1088245a2de3b7d09d39cd209212eb16af
> "mfd: Provide the tc3589x with its own IRQ domain"
>
> If a system with a TC3589x expander is booted and a base
> IRQ is passed from platform data, a legacy domain will
> be used. However, since the Ux500 is now switched to use
> SPARSE_IRQ, no descriptors get allocated on-the-fly,
> and we get a crash.
>
> Fix this by switching to using the simple irqdomain that
> will handle this uniformly and also allocates descriptors
> explicitly.
>
> Also fix two small whitespace errors in the vicinity while
> we're at it.
>
> Cc: stable@kernel.org
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> ChangeLog v1->v2:
> - Update commit message after comments from Lee, add ACK, no
>   changes to the patche per se.

Ping on this regression fix patch as well...

Yours,
Linus Walleij
