Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaG3Mgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:36:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55473 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752864AbaG3Mgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:36:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: linux-next: manual merge of the pm tree with the arm-soc tree
Date: Wed, 30 Jul 2014 14:55:04 +0200
Message-ID: <2943176.NOpchz9a7V@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140730122305.7b1b7838@canb.auug.org.au>
References: <20140730122305.7b1b7838@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2014 12:23:05 PM Stephen Rothwell wrote:
> 
> --Sig_/ACOdpNyKdCGq/4_bRoeLLze
> Content-Type: text/plain; charset=US-ASCII
> Content-Transfer-Encoding: quoted-printable
> 
> Hi Rafael,

Hi Stephen,

> Today's linux-next merge of the pm tree got a conflict in
> drivers/cpuidle/Kconfig.arm between commit 2aaafcdb6883 ("cpuidle:
> big.LITTLE: Add ARCH_EXYNOS entry in config") from the arm-soc tree and
> commit 6ee7f5dd57fc ("cpuidle: big_little: Fix build error") from the
> pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for the fix!


> diff --cc drivers/cpuidle/Kconfig.arm
> index 33fc0ff0af1c,a186dec8e5df..000000000000
> --- a/drivers/cpuidle/Kconfig.arm
> +++ b/drivers/cpuidle/Kconfig.arm
> @@@ -1,9 -1,16 +1,10 @@@
>   #
>   # ARM CPU Idle drivers
>   #
>  -config ARM_ARMADA_370_XP_CPUIDLE
>  -	bool "CPU Idle Driver for Armada 370/XP family processors"
>  -	depends on ARCH_MVEBU
>  -	help
>  -	  Select this to enable cpuidle on Armada 370/XP processors.
>  -
>   config ARM_BIG_LITTLE_CPUIDLE
>   	bool "Support for ARM big.LITTLE processors"
>  -	depends on ARCH_VEXPRESS_TC2_PM
>  +	depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS
> + 	depends on MCPM
>   	select ARM_CPU_SUSPEND
>   	select CPU_IDLE_MULTIPLE_DRIVERS
>   	help
> 
> --Sig_/ACOdpNyKdCGq/4_bRoeLLze
> Content-Type: application/pgp-signature; name=signature.asc
> Content-Disposition: attachment; filename=signature.asc
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2
> 
> iQIcBAEBCAAGBQJT2FcWAAoJEMDTa8Ir7ZwVpXAP/i6U5VfuEjywNOnyq2GF13qx
> gpKWy6BNWg6TACRERzfngwOBID7nUVeQH3ksri2ReiDJkjM655dOnR2T1d4q+Txc
> CYc+TYp1x37ErXOVarlrnoVSqeNKSiARQdKLSE0ztLWfg/s+zmAuCjznbbBkFwyo
> tEbfa7kkMRo6TBopPVHevQ/Pe/s0ZVFXqS8KNyd5XImgeEmUAnvGl0KBSetA+b8u
> 1zB/U8V7d4cnWH6jRiijVDOBBs1RlmTJHV12NeKWzukjjEWd8QJ2cQHLRo/aS/js
> AVwCMUE5Q5AFAOj+aLtETpo2wc3VPNkq6QwFk4sJgmizvISQ5l/8nveBJgGU457m
> XQAHlgvhWAArtD2uowLP/aGhUJE3D3MBDs/6r/eMxfYeTBJSgfLllz9jXTayfshM
> 7saBQtwh+npKK2M4tDivUGE0zFoRj/qcCdiSB/+r0XYGaFwGIqoqEHnlsS/YElUF
> HJBCQgUPpzv832JXuJUuR5RnCOiGYiWlTGBs+WHoWXgVpVyIpZOfOPGinTbaOgIa
> 23OHAdHLTdWTg+adfKmrTGPu++OTxI985oooYhqHsmpp6MPLxC6ABgqlWlUh15zb
> sNs02B6XLBvm6Sa4v3w2anYAZCtwrO3TcihsL5mFhLHxForyq+U45qbktcZ6CBbF
> xI0c32N77d98oZMV81vN
> =U/IC
> -----END PGP SIGNATURE-----
> 
> --Sig_/ACOdpNyKdCGq/4_bRoeLLze--
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
