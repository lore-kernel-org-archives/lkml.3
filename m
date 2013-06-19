Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935334Ab3FSWmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:42:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934961Ab3FSWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:42:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH v2 2/4] tty/8250_dw: Add support for OCTEON UARTS.
Date: Thu, 20 Jun 2013 00:42:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
References: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com> <1371677849-23912-3-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1371677849-23912-3-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306200042.19064.arnd@arndb.de>
X-Provags-ID: V02:K0:j4bdPI5/1JWHBI4KwaAUZ/ht14f8HAxX9Jz1RYslcqw
 7FYECc37pjxHU7Jta9+7srUVNmbzguNiyD+ntaSBcgH0EU3Ly+
 kHGylqRzqZOTalmNxrU/oEbZ/5KZW40bUopxNu6XrDucT1JjdI
 BTxAYWcglgZtpCadWnyKz8+s+Wv1VXH/Hym0moVfzeBWHVYI+/
 DSPE/UiHtqUPIckLee8q17TfREYNNRJdzFnbyZmr+5W1t1RRHU
 vb23fFcDinmwIHSzFrT+3gEXOPg0mU0sGMv6ulsum6qmZKteAM
 33U/wlo5GAJER5eDiCy7pkuD6Z/MOJuPtO/kgb2kiK0zdd8QQE
 Pk1uSO8XvDNcGUro3o9U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> A few differences needed by OCTEON:
> 
> o These are DWC UARTS, but have USR at a different offset.
> 
> o Internal SoC buses require reading back from registers to maintain
>   write ordering.
> 
> o 8250 on OCTEON appears with 64-bit wide registers, so when using
>   readb/writeb in big endian mode we have to adjust the membase to hit
>   the proper part of the register.
> 
> o No UCV register, so we hard code some properties.
> 
> Because OCTEON doesn't have a UCV register, I change where
> dw8250_setup_port(), which reads the UCV, is called by pushing it in
> to the OF and ACPI probe functions, and move unchanged
> dw8250_setup_port() earlier in the file.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
