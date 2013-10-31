Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3JaKf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:35:27 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39184 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3JaKfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:35:24 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20131031184015.adc000259e9931fd0b5d5cf7@canb.auug.org.au>
References: <20131031184015.adc000259e9931fd0b5d5cf7@canb.auug.org.au>
Date: Thu, 31 Oct 2013 11:35:23 +0100
Message-ID: <CA+icZUWYHSU3yvsW6fB5aKJ0LQVaY0afsF2DiS9=m_bzy80=hw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tty tree
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Philippe Proulx <philippe.proulx@savoirfairelinux.com>
Cc: Greg KH <greg@kroah.com>, linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 8:40 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> After merging the tty tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>
> drivers/tty/serial/omap-serial.c: In function 'serial_omap_probe':
> drivers/tty/serial/omap-serial.c:1724:22: error: expected ')' before numeric constant
> drivers/tty/serial/omap-serial.c:1724:22: warning: format '%d' expects a matching 'int' argument [-Wformat]
>
> Caused by commit e5f9bf72efbc ("serial: omap: fix a few checkpatch
> warnings").  There is a missing ',' in the dev_warn() ...
>
> I have used the version of the tty tree from next-20131030 for today.
>

[ Add CC to linux-serial ML ]

Happy HelloWien and WelcomeBackStephen!

That was only checkpatch-tested, eh :-)?

@@ -1724,8 +1722,9 @@ static int serial_omap_probe(struct platform_device *pdev)
up->port.uartclk = omap_up_info->uartclk;
if (!up->port.uartclk) {
up->port.uartclk = DEFAULT_CLK_SPEED;
- dev_warn(&pdev->dev, "No clock speed specified: using default:"
- "%d\n", DEFAULT_CLK_SPEED);
+ dev_warn(&pdev->dev,
+ "No clock speed specified: using default: %d\n" <--- Comma missing here!
+ DEFAULT_CLK_SPEED);
}

- Sedat -
