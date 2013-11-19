Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3KSOLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:11:45 -0500
Received: from gw1.transmode.se ([195.58.98.146]:53484 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3KSOLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:11:43 -0500
In-Reply-To: <20131118070423.E47181A4D3D@localhost.localdomain>
References: <20131118070423.E47181A4D3D@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Marcelo Tosatti <marcelo@kvack.org>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Vitaly Bordug <vitb@kernel.crashing.org>
MIME-Version: 1.0
Subject: Re: [PATCH] lib/crc32: slice by 4 is more efficient than the default slice
 by 8 on Powerpc 8xx.
X-KeepSent: 5004EA63:AA9B7989-C1257C28:004D6C13;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF5004EA63.AA9B7989-ONC1257C28.004D6C13-C1257C28.004DF922@transmode.se>
Date: Tue, 19 Nov 2013 15:11:40 +0100
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 19/11/2013 15:11:40,
	Serialize complete at 19/11/2013 15:11:40
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the same on MPC8321 long time ago(when 64 bits change went in), 
the 32 bits were much faster. I guess the "smaller"
CPUs cannot handle the cache trashing these big tables impose, I didn't 
look into the details though.
So I think this is a good change for 8xx.

Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2013/11/18 08:04:23:

> From: Christophe Leroy <christophe.leroy@c-s.fr>
> To: Vitaly Bordug <vitb@kernel.crashing.org>, Marcelo Tosatti 
<marcelo@kvack.org>, Joakim Tjernlund <joakim.tjernlund@transmode.se>, Bob 
Pearson <rpearson@systemfabricworks.com>, 
> Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
> Date: 2013/11/19 13:05
> Subject: [PATCH] lib/crc32: slice by 4 is more efficient than the 
default slice by 8 on Powerpc 8xx.
> 
> On PPC_8xx, CRC32_SLICEBY4 is more efficient (almost twice) than 
CRC32_SLICEBY8,
> as shown below:
> 
> With CRC32_SLICEBY8:
> [    1.109204] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> [    1.114401] crc32: self tests passed, processed 225944 bytes in 
15118910 nsec
> [    1.130655] crc32c: CRC_LE_BITS = 64
> [    1.134235] crc32c: self tests passed, processed 225944 bytes in 
4479879 nsec
> 
> With CRC32_SLICEBY4:
> [    1.097129] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
> [    1.101878] crc32: self tests passed, processed 225944 bytes in 
8616242 nsec
> [    1.116298] crc32c: CRC_LE_BITS = 32
> [    1.119607] crc32c: self tests passed, processed 225944 bytes in 
3289576 nsec
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> Index: a/lib/Kconfig
> ===================================================================
> --- a/lib/Kconfig   (révision 5325)
> +++ b/lib/Kconfig   (copie de travail)
> @@ -102,6 +102,7 @@
>  choice
>     prompt "CRC32 implementation"
>     depends on CRC32
> +   default CRC32_SLICEBY4 if PPC_8xx
>     default CRC32_SLICEBY8
>     help
>       This option allows a kernel builder to override the default choice

