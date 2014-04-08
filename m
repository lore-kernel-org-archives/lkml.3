Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaDHP74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:59:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37623 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbaDHP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:59:54 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-20-53441cf8297a
Message-id: <53441CF5.80003@samsung.com>
Date: Tue, 08 Apr 2014 17:59:49 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com
Subject: Re: [PATCH 01/10] ARM: EXYNOS: Cleanup  "mach-exynos/common.h" file
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1396425058-4012-2-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1396425058-4012-2-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xq7o/ZFyCDVrW81ksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd2B3aOluYfNY/OSeo++LasYPT5vkgtgieKySUnN
	ySxLLdK3S+DKuPZ3FlvBPM6KE59esDYw7mfvYuTkkBAwkfh1/hYrhC0mceHeerYuRi4OIYGl
	jBKnz1xjgnA+M0pM2dENVsUroCHxfNMfIJuDg0VAVWLz0iqQMJuAmsTnhkdsIDa/gJbEmqbr
	LCC2qECExL3Gw1CtghI/Jt9jAZkpIjCNUeL6jEZ2kDnMAu4Sd85JgdQIC/hI3O85yQKxt5VR
	Yvet9WBDOQU8JCYvXMAMYjMLWEusnLSNEcKWl9i85i3zBEbBWUh2zEJSNgtJ2QJG5lWMoqml
	yQXFSem5hnrFibnFpXnpesn5uZsYIQH/ZQfj4mNWhxgFOBiVeHgrjzgFC7EmlhVX5h5ilOBg
	VhLhvSrlEizEm5JYWZValB9fVJqTWnyIkYmDU6qBUfO5+14evmMX/y1etEfzR3pV3nvbqUKM
	XF2ZZ45EH10yfzbHkzi1p+z/su349iTdfXY8YM+P1L916+5Yycmeesuwx/TMr+vTcmL0V0nW
	X9r/XyhqbUHH9pgrOQ/zlMLqPuy/Gb9/wdffzv72SvfF4iqXfv1u2pUYw5/383iSLaOoyNLy
	WVcFTJRYijMSDbWYi4oTAZZrVkBWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 02.04.2014 09:50, Pankaj Dubey wrote:
> Remove unused declarations from "mach-exynos/common.h"
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   arch/arm/mach-exynos/common.h |    3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
> index 9ef3f83..277a83e 100644
> --- a/arch/arm/mach-exynos/common.h
> +++ b/arch/arm/mach-exynos/common.h
> @@ -15,9 +15,6 @@
>   #include <linux/reboot.h>
>   #include <linux/of.h>
>
> -void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
> -
> -struct map_desc;
>   void exynos_init_io(void);
>   void exynos_restart(enum reboot_mode mode, const char *cmd);
>   void exynos_cpuidle_init(void);
>

You could also drop a bit more. From the context above I can see that at 
least exynos_restart() and exynos_init_io() are never used outside of 
files they are defined in, so they too could be dropped from this 
header. Looking at rest of the header, there seems to be a lot of 
similar definitions. If cleaning up the header anyway, could you take 
care of them as well?

Best regards,
Tomasz
