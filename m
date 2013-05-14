Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3ENIaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:30:21 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47115 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab3ENIaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <1368019749-19455-7-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-7-git-send-email-lee.jones@linaro.org>
Date: Tue, 14 May 2013 10:30:18 +0200
Message-ID: <CACRpkdYz0HcdBovoJu6O-4QyRbXz93MaeWwAwCohbE8rv=8O7Q@mail.gmail.com>
Subject: Re: [PATCH 6/9] ARM: ux500: Provide device enumeration number suffix
 for SMSC911x
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 3:29 PM, Lee Jones <lee.jones@linaro.org> wrote:

> First Ethernet device has a ".0" appended onto the device name. It
> appears that we need this in order to obtain the correct clock.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
(...)
> -       OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x", NULL),
> +       OF_DEV_AUXDATA("smsc,lan9115", 0x50000000, "smsc911x.0", NULL),

I guess what you want to say in the commit message is that
on a non-DT boot the ethernet will be named "smsc911x.0"
and since the clocks are not converted to device tree these
names need to be matched when providing the name from
auxdata.

Edited the commit message and applied!

Yours,
Linus Walleij
