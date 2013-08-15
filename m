Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3HOLft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:35:49 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56411 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3HOLfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:35:47 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v3 03/16] driver/core: cpu: initialize of_node in cpu's device struture
Date: Thu, 15 Aug 2013 13:35:37 +0200
Message-ID: <1804645.BcbkbcfKAA@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.6-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1374492747-13879-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1593743.3tsGmby197"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1593743.3tsGmby197
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Sudeep,

On Monday 22 of July 2013 12:32:14 Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> CPUs are also registered as devices but the of_node in these cpu
> devices are not initialized. Currently different drivers requiring
> to access cpu device node are parsing the nodes themselves and
> initialising the of_node in cpu device.
> 
> The of_node in all the cpu devices needs to be initialized properly
> and at one place. The best place to update this is CPU subsystem
> driver when registering the cpu devices.
> 
> The OF/DT core library now provides of_get_cpu_node to retrieve a cpu
> device node for a given logical index by abstracting the architecture
> specific details.
> 
> This patch uses of_get_cpu_node to assign of_node when registering the
> cpu devices.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/base/cpu.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 4c358bc..ea51c6d 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -14,6 +14,7 @@
>  #include <linux/slab.h>
>  #include <linux/percpu.h>
>  #include <linux/acpi.h>
> +#include <linux/of.h>
> 
>  #include "base.h"
> 
> @@ -289,6 +290,7 @@ int register_cpu(struct cpu *cpu, int num)
>  	cpu->dev.release = cpu_device_release;
>  	cpu->dev.offline_disabled = !cpu->hotpluggable;
>  	cpu->dev.offline = !cpu_online(num);
> +	cpu->dev.of_node = of_get_cpu_node(num);

Aha, so this would be the only place where of_get_cpu_node() gets called, 
so the parsing would be done only once and then any code that needs CPU DT 
node would just simply grab it from CPU dev. Fair enough.

Not sure if this makes the need for such helper to be globally available 
in of/base.c, but I guess this won't hurt.

Best regards,
Tomasz

--nextPart1593743.3tsGmby197
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABAgAGBQJSDL0MAAoJEIv3Hb8G/XruHhQQAMwrPrJW7AHY2OW8wcNywxUg
g/HucVy/LwayRHvrMeNY4knEDqw+eK3Hv3pyhuvbaIUnbol/ZxDvG430L0LRRni/
XWf4/IvWdxLc3LEVMlYZssJJzUV5odnLcXP1ate1i0LShWj2Atf9H1QmnTJlVMmx
OZTwaznLZlOFr1A0/3lrSxUhsbjIJKkesg3kOCS4nYOigE2oxakWQEJiWAErYG21
9dh/E7ptP2tdATuu2jAn6dhfmT6t8mTMSP+I0qb3Iq3ht6HxqN2nNkflBtpMzCBH
52SpV4gJd18PxJd7qRNRqPLf8pwRuIttiqOCCPfINCW1qAXp+71MJn9e4STyhYTS
pPQhXXe4SVDaBpNju/M4WKZqPpJ0iBaPI8LwkLsaED+W8Pqsv/5VjoggBYG5q3x0
kJ0MYw1tQHiZjw3FgbdGQHLCm/M1pWM8pglMfZex5bgQem85FM0ke3U1I1kE+P/J
D/S66R8ea/w+NMXdxxzIxasMPFwv3/Z9XokDVRnz4OJJW90dg2/unngKsIgWuabJ
pKtx6aX0jW2491cBRmqrwG627iomcvGVlLhg0xH/iZlkGVJlYEqSa6olUO/wXXbe
8UKHudVMU+VRRZHbNCMC6je+ZE8gbscEUqwdhAdLmuqPPmtgiMkbQHxMnZA1ye+8
J8pVzM0274H6tN14syA3
=ZBux
-----END PGP SIGNATURE-----

--nextPart1593743.3tsGmby197--

