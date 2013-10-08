Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3JHTDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:03:12 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:40751 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3JHTDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:03:10 -0400
Date: Tue, 8 Oct 2013 21:03:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Mike Frysinger <vapier@gentoo.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: warn about headers using __[us]{8, 16, 32, 64}
 types w/out linux/types.h
In-Reply-To: <20081230104303.GA486@uranus.ravnborg.org>
Message-ID: <alpine.DEB.2.02.1310082100020.2894@ayla.of.borg>
References: <1230553127-953-1-git-send-email-vapier@gentoo.org> <20081229132456.GA6938@uranus.ravnborg.org> <200812291527.53317.vapier@gentoo.org> <20081230104303.GA486@uranus.ravnborg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Sam Ravnborg wrote:
> Subject: [PATCH] kbuild: add checks for include of linux/types in userspace headers

> If we see __[us](8|16|32|64) then we must include <linux/types.h>

> +	if ($line =~ m/__[us](8|16|32|64)\b/) {
> +		printf STDERR "$filename:$lineno: " .
> +		              "found __[us]{8,16,32,64} type " .
> +		              "without #include <linux/types.h>\n";
> +		$linux_types = 2;
> +		# Warn until headers are all fixed
> +		#$ret = 1;
> +	}

FWIW, this also triggers on __[us]{8,16,32,64} in comments instead of in
actual code (just got caught ;-).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
