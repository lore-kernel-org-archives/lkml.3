Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab3GDIz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:55:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3GDIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:55:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 4/4] checkpatch: only allow COMPILE_TEST in Kconfig dependency lines
Date: Thu, 4 Jul 2013 10:55:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com> <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307041055.06561.arnd@arndb.de>
X-Provags-ID: V02:K0:MpMUqFdbI1SKqYoB/Gk3CBO8Y7NxvshLO5oxHLnVHzL
 oG2/DuCJ9uTLlQX4J3oSpxQ93et/B3YUfkMtORrMtZZ+/eTIRa
 Br8Chif7A0tjKHaotb/2kBGdq1JxcExbkFZBq6tvHkGkwAzxt8
 Yv95qKermqYrk9E9gqYkjjIGVqJkwRBv0Z20W9l4n9bsoX7u1b
 vbdK0SWxtQWao1pVNsY8B0/T+eSuAuMHKsTTOm65VeZZmEHWoY
 r7Ln1wXj9L5BhkQaZMxI8BFRmPFl5fU1zbCkEr3zES7y+1hn96
 V/+tHb7D1ORrU6zEaWajsfic338QSU16rNOQO1JRb9BJrAIQHn
 QZ/pz2gnQbuZouB5O4T8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 July 2013, Paul Gortmaker wrote:
> The option CONFIG_COMPILE_TEST, added in commit 4bb1667255a
> ("build some drivers only when compile-testing") is meant to
> give a middle ground[1] between those who want the widest compile
> coverage possible (e.g. building sparc drivers for mips) and
> those who want dependencies to represent real world systems
> (e.g. don't allow me to see OMAP options when building x86).
> 
> As such, this addition is meant to be used in dependency lines,
> properly or'd in with the real world hardware dependency.  Those
> who select it, get wide compile coverage.  Those who do not, get
> real world dependencies that match where the hardware is available
> and/or where the driver is useful.
> 
> With that in mind, it is clear that this is _not_ to be used in
> any C code with "#ifdef CONFIG_COMPILE_TEST" etc.  However there
> will (and already has been) instances of people thinking this is
> an OK practice[2].  So teach checkpatch to spot them as an error.
> 
> [1] https://lkml.org/lkml/2013/3/7/456
> [2] https://lkml.org/lkml/2013/7/1/641
> 
> Cc: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
