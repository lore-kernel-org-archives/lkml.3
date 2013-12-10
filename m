Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3LJIue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:50:34 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33994 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3LJIua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131210140218.645eaf6983481bafe5833eef@canb.auug.org.au>
References: <20131210140218.645eaf6983481bafe5833eef@canb.auug.org.au>
Date: Tue, 10 Dec 2013 09:50:30 +0100
Message-ID: <CACRpkdYznRuiwgbZMZqz9UDsgPiOgs7t8i8cVm+d4ykhMXMz2Q@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pinctrl tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 4:02 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the pinctrl tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> sound/soc/fsl/eukrea-tlv320.c:28:28: fatal error: asm/mach-types.h: No such file or directory
>  #include <asm/mach-types.h>
>                             ^

It is trying to include an ARM-only file in an x86_64 compile...
I think the Kconfig for that driver needs a

depends on ARM

Yours,
Linus Walleij
