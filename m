Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaFPXy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:54:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:54064 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbaFPXy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:54:26 -0400
Message-ID: <1402962847.7661.82.camel@pasglop>
Subject: Re: [PATCH] offb: Fix little-endian support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Cedric Le Goater <clg@fr.ibm.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 09:54:07 +1000
In-Reply-To: <1402904135.7661.34.camel@pasglop>
References: <1400073709-15012-1-git-send-email-tiwai@suse.de>
	 <1402904135.7661.34.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 17:35 +1000, Benjamin Herrenschmidt wrote:

> I somewhat doubt that this (and 5:5:5) actually work, do they ? the
> green gets split into two separate fields, which we can't express
> properly here...

So the conclusion of further investigation is:

 - The right fix is to fix qemu to flip endian

 - There's an open discussion as to whether qemu could do it
automatically when the guest endian changes on powerpc as a quick fix,
the long run approach is to have a register to control it, I'm working
on it. offb can then "learn" to flick it like it does the palette hack
today.

 - If we want to ever support foreign endian offb with X, we need to do
things a bit differently based on the foreign endian bit that is already
there.

 - We must revert the existing cmap swap patch from the kernel, it's
broken and will break things when we fix qemu (and breaks with real HW
in LE mode). I've sent a revert request to Linus and CC'ed stable.

Cheers,
Ben.


