Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaFJVvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:51:02 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:35746 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaFJVvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <86ha3so84o.fsf@void.printf.net>
References: <86ha3so84o.fsf@void.printf.net>
Date: Tue, 10 Jun 2014 14:50:59 -0700
X-Google-Sender-Auth: UycULMwTw8UYXhEaw_I8Eo2FPd4
Message-ID: <CA+55aFxBwteZeUHG+Z-cdLU_YCO4f8TDuYvGmXc0-v9M1H11+g@mail.gmail.com>
Subject: Re: [GIT PULL] MMC updates for 3.16-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Ball <chris@printf.net>, Mike Turquette <mturquette@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:51 PM, Chris Ball <chris@printf.net> wrote:
>
>  These patches have been tested in
> linux-next, and there are three minor conflicts which I've resolved on
> my mmc-updates-for-3.16-rc1-merged branch.

Your merged branch is incorrect as far as I can tell, and dropped
commit a8246fedacad ("dmaengine: omap: hide filter_fn for built-in
drivers").

And I'm not sure why the sunxi driver (by David Lanzendörfer) and the
Realtek driver (by Roger Tseng) got merged in two different trees.
It's clearly the same patches and drivers, but I got them first
through the MFD tree (Realtek) and the clock tree (sunxi) trees and
now the MMC tree.

Don't you guys talk to each other? The Realtek driver is even marked
as Acked-by Chris Ball in the MFD tree.

Also, that new drivers/mmc/host/usdhi6rol0.c driver is one f*cking
noisy compile, and knisr certainly has never been tested in a 64-bit
environment. Please either fix it, or make it depend on BROKEN.

Grr.

Anyway, pulled, merged correctly, and pushed out..

                Linus
