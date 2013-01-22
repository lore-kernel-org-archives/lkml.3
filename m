Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3AVIDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:03:31 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40309 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3AVID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
Date: Tue, 22 Jan 2013 09:03:26 +0100
Message-ID: <CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 1:24 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:

> While (1) was fixed by now, I can't bisect (2) since (1) is preventing (2) from
> printing messages.

I usually bisect like this:

1.  Get hold of the patch fixing the boot regression:
    git format-patch
f5565295892eb93c3191aa241405fe8b685542d6^..f5565295892eb93c3191aa241405fe8b685542d6

2. At each iterative step using git bisect:
   patch -p1 < 0001-ARM-7610-1-versatile-bump-IRQ-numbers.patch

3. Boot/trial-and-horror

4. git reset --hard HEAD
   To nullify the effects of the patch.

5. git bisect [good|bad]

6. Iterate from (2) until you find the bug.

Yours,
Linus Walleij
