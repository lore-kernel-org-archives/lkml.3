Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3G3PyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:54:18 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:27350 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3G3PyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:54:16 -0400
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2013 11:54:16 EDT
Date: Tue, 30 Jul 2013 15:40:01 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: debian-68k@lists.debian.org
cc: linux-btrfs@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
In-Reply-To: <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
Message-ID: <Pine.BSM.4.64L.1307301539150.28836@herc.mirbsd.org>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven dixit:

>   0:	222e ff74      	movel %fp@(-140),%d1
>   4:	2a2e ff5c      	movel %fp@(-164),%d5
>   8:	2c2e ff60      	movel %fp@(-160),%d6
>   c:	4c45 1402     <	divul %d5,%d2,%d1 >
>  10:	2d40 ff64      	movel %d0,%fp@(-156)
>  14:	2d41 ff68      	movel %d1,%fp@(-152)
>  18:	2205           	movel %d5,%d1
>  1a:	4c2e 1800 ff68 	mulsl %fp@(-152),%d1
>  20:	4c04 0800      	mulsl %d4,%d0
>  24:	2041           	moveal %d1,%a0
>  26:	d1c0           	addal %d0,%a0
>  28:	2206           	movel %d6,%d1
>  2a:	4c2e 1400 ff68 	mulul %fp@(-152),%d0,%d1

This is gcc-4.8 compiled, btw… in case that’s a known issue.

bye,
//mirabilos
-- 
“It is inappropriate to require that a time represented as
 seconds since the Epoch precisely represent the number of
 seconds between the referenced time and the Epoch.”
	-- IEEE Std 1003.1b-1993 (POSIX) Section B.2.2.2
