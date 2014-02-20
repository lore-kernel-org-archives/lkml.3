Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaBTPY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:24:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaBTPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:24:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] rename HAS_IOPORT to HAS_IOPORT_MAP
Date: Thu, 20 Feb 2014 16:24:19 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
References: <1392854190-29596-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1392854190-29596-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201402201624.19922.arnd@arndb.de>
X-Provags-ID: V02:K0:wh6qHUWObMUv/vn0TNA/w7VQIhc3yOLA4LyKfcmcXGv
 UPZgRloJt3KTbqtBH7Xr/L3ttfjJu5BwAl+wxObufe8rt/e0Va
 +jGBYz9+O4eTZybbHDNEFzBgDrcXNQrHSFqODZ5LLNjQAab98N
 SGhyFnG+VG6FqxRTHN4Ec2ertwgAdKUygppC66cJm9U3b7oKBE
 Zl8TQHVyxLkr0hK/hfUbIztCtAP0ImuBDGAEMJK+pYMlI/WMVv
 Lfht0D90K76MLwzDYIjlIJfBhDOsW+TEe7Bel6CaihzFKXa2aO
 jDm3m2rjKz8nvZZK9k7DZPWYk6PdynloEzoPEIJBlI6Pq1Xhna
 W+nFSEDkBhipISnwMh6c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 February 2014, Uwe Kleine-König wrote:
> If the renamed symbol is defined lib/iomap.c implements ioport_map and
> ioport_unmap and currently (nearly) all platforms define the port
> accessor functions outb/inb and friend unconditionally. So
> HAS_IOPORT_MAP is the better name for this. Consequently NO_IOPORT is
> renamed to NO_IOPORT_MAP.
> 
> The motivation for this change is to reintroduce a symbol HAS_IOPORT
> that signals if outb/int et al are available. I will address that
> at least one merge window later though to keep surprises to a minimum
> and catch new introductions of (HAS|NO)_IOPORT.
> 
> The changes in this commit were done using:
> 
>         $ git grep -l -E '(NO|HAS)_IOPORT' | xargs perl -p -i -e 's/\b((?:CONFIG_)?(?:NO|HAS)_IOPORT)\b/$1_MAP/'
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks for taking up that work, I had a similar patch series
some years ago but never followed through with getting it upstream.
If there are no objections, I hope Andrew can queue it up for -mm.
Unfortunately I can't think of a good way to split up the patch
into smaller units that could go through subsystem maintainer
trees, since we want to start reusing the symbol as soon as possible.

Acked-by: Arnd Bergmann <arnd@arndb.de>
