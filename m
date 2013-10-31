Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3JaNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:09:56 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:56549 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3JaNJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:09:54 -0400
Date: Thu, 31 Oct 2013 09:09:51 -0400 (EDT)
From: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
To: sedat dilek <sedat.dilek@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <73605653.13929.1383224991870.JavaMail.root@mail>
In-Reply-To: <CA+icZUWYHSU3yvsW6fB5aKJ0LQVaY0afsF2DiS9=m_bzy80=hw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tty tree
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC30 (Win)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Sedat Dilek" <sedat.dilek@gmail.com>
> To: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Philippe Proulx" <philippe.proulx@savoirfairelinux.com>
> Cc: "Greg KH" <greg@kroah.com>, "linux-next" <linux-next@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
> linux-serial@vger.kernel.org
> Sent: Thursday, 31 October, 2013 6:35:23 AM
> Subject: Re: linux-next: build failure after merge of the tty tree
> 
> On Thu, Oct 31, 2013 at 8:40 AM, Stephen Rothwell
> <sfr@canb.auug.org.au> wrote:
> > Hi Greg,
> >
> > After merging the tty tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >
> > drivers/tty/serial/omap-serial.c: In function 'serial_omap_probe':
> > drivers/tty/serial/omap-serial.c:1724:22: error: expected ')'
> > before numeric constant
> > drivers/tty/serial/omap-serial.c:1724:22: warning: format '%d'
> > expects a matching 'int' argument [-Wformat]
> >
> > Caused by commit e5f9bf72efbc ("serial: omap: fix a few checkpatch
> > warnings").  There is a missing ',' in the dev_warn() ...
> >
> > I have used the version of the tty tree from next-20131030 for
> > today.
> >
> 
> [ Add CC to linux-serial ML ]
> 
> Happy HelloWien and WelcomeBackStephen!
> 
> That was only checkpatch-tested, eh :-)?
> 
> @@ -1724,8 +1722,9 @@ static int serial_omap_probe(struct
> platform_device *pdev)
> up->port.uartclk = omap_up_info->uartclk;
> if (!up->port.uartclk) {
> up->port.uartclk = DEFAULT_CLK_SPEED;
> - dev_warn(&pdev->dev, "No clock speed specified: using default:"
> - "%d\n", DEFAULT_CLK_SPEED);
> + dev_warn(&pdev->dev,
> + "No clock speed specified: using default: %d\n" <--- Comma missing
> here!

Oops, something obviously went wrong in my process. Sorry about this.

Do you want me to fix this commit?

> + DEFAULT_CLK_SPEED);
> }
> 
> - Sedat -
> 
