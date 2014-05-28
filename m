Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaE1PeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:34:11 -0400
Received: from mail.mycable.de ([46.4.59.52]:51562 "EHLO mail.mycable.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbaE1PeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:34:09 -0400
Message-ID: <538601ED.8030601@mycable.de>
Date: Wed, 28 May 2014 17:34:05 +0200
From: Michael Stickel <ms@mycable.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the gpio tree with Linus' tree
References: <20140528190011.302a2e52@canb.auug.org.au> <20140528133832.GA2541@deathray>
In-Reply-To: <20140528133832.GA2541@deathray>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.05.2014 15:38, schrieb Michael Welling:
> Looking at the Linux next version, I am fairly certian that the following is
> redundant checking:
>                 if (chips < 0) {
>                         dev_err(&spi->dev, "FATAL: invalid negative chip id\n");
>                         goto fail;
>                 }
> 
> The chips variable should equal the number of bits in the spi_present_mask variable.
> Or am I missing something?

Can be left out. Was just a paranoid check, because with the missing
increment in the of path it became negative.


-- 
------------------------------------------------------------------------
   Michael Stickel                Tel.   +49 4321 559 56-29
   mycable GmbH                   Fax    +49 4321 559 56-10
   Gartenstrasse 10
   24534 Neumuenster, Germany     Email ms@mycable.de
------------------------------------------------------------------------
   mycable GmbH, Managing Director: Michael Carstens-Behrens
   USt-IdNr: DE 214 231 199, Amtsgericht Kiel, HRB 1797 NM
------------------------------------------------------------------------
   This e-mail and any files transmitted with it are confidential and
   intended solely for the use of the individual or entity to whom
   they are addressed. If you have received this e-mail in error,
   please notify the sender and delete all copies from your system.
------------------------------------------------------------------------
