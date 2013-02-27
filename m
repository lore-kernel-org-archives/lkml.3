Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3B0I0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:26:31 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62635 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3B0I0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:26:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
References: <1352665488-13818-1-git-send-email-mathieu.poirier@linaro.org>
	<20121119072525.GA16730@core.coreip.homeip.net>
	<CAPM=9tw8mefcYTqELXFbZWZ44a--SNcPnRMAvMSGTiODzRpDhg@mail.gmail.com>
Date: Wed, 27 Feb 2013 18:26:29 +1000
Message-ID: <CAPM=9tzyBuxwLS=0vAcF5h4vZnB01X7_1NbnMo0M=M454gwZBQ@mail.gmail.com>
Subject: Re: [PATCH v4] drivers/tty: Folding Android's keyreset driver in sysRQ
From: Dave Airlie <airlied@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org, arve@android.com,
        kernel-team@android.com, john.stultz@linaro.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> this patch seems to be oopsing on my x86 32-bit machine on bootup, pic attached.
>
> .config attached.
>
> It looks to me like the weak bit isn't working so well
>
>         if (platform_sysrq_reset_seq) {
>                 for (i = 0; i < ARRAY_SIZE(sysrq_reset_seq); i++) {
>                         key = platform_sysrq_reset_seq[i];
>   6d:   66 8b 8c 00 00 00 00    mov    0x0(%eax,%eax,1),%cx
>   74:   00
>
> is around where it craps out.
> gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC)
> Fedora 18 machine.

And just to confirm reverting
154b7a489a5b1d808323b933b04864958c2f1056.in Linus' tree allows boot to
proceed.

Dave.
