Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaFCHBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:01:00 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64093 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaFCHA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:00:57 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [RFC PATCH 2/3] DMA, CMA: use general CMA reserved area management framework
In-Reply-To: <1401757919-30018-3-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com> <1401757919-30018-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140603:aneesh.kumar@linux.vnet.ibm.com::UYcpFzTuHF17hT1u:0000000000000000000000000000000UT6
X-Hashcash: 1:20:140603:akpm@linux-foundation.org::Bf9r10RQUyQg19Aq:0000000000000000000000000000000000000KBt
X-Hashcash: 1:20:140603:linux@arm.linux.org.uk::fgwpK59rCMOEQIl2:0000000000000000000000000000000000000000WTW
X-Hashcash: 1:20:140603:iamjoonsoo.kim@lge.com::XsKEBimhu72BKVsT:00000000000000000000000000000000000000011vL
X-Hashcash: 1:20:140603:linux-arm-kernel@lists.infradead.org::ivmbVEZtQg37hoNq:00000000000000000000000000+3J
X-Hashcash: 1:20:140603:gregkh@linuxfoundation.org::ev/RNg8ADTeHUSW9:000000000000000000000000000000000001gRG
X-Hashcash: 1:20:140603:m.szyprowski@samsung.com::Gr+/YADo4ler7n0A:00000000000000000000000000000000000001cBT
X-Hashcash: 1:20:140603:iamjoonsoo.kim@lge.com::BdzSd6XVBuEomHTt:0000000000000000000000000000000000000002jAC
X-Hashcash: 1:20:140603:gleb@kernel.org::onefDyaktWUvC16t:001Zkx
X-Hashcash: 1:20:140603:paulus@samba.org::TW6JsM0xDjg1I3Bt:03ZCL
X-Hashcash: 1:20:140603:agraf@suse.de::GcAtOZp7JGeyR2+E:00003451
X-Hashcash: 1:20:140603:kvm@vger.kernel.org::hy3X5H4bfdqKz1lH:0000000000000000000000000000000000000000003rH7
X-Hashcash: 1:20:140603:benh@kernel.crashing.org::3ajwaQY/TfrfRl3W:00000000000000000000000000000000000003soO
X-Hashcash: 1:20:140603:minchan@kernel.org::0TziF21I9t+PdlVQ:00000000000000000000000000000000000000000004Y8U
X-Hashcash: 1:20:140603:pbonzini@redhat.com::vFvdIAbwxpMIHFKE:0000000000000000000000000000000000000000004net
X-Hashcash: 1:20:140603:kvm-ppc@vger.kernel.org::CznBgB5p2eCuA+1j:000000000000000000000000000000000000006CRE
X-Hashcash: 1:20:140603:linuxppc-dev@lists.ozlabs.org::l+fPkRMV0+bhJUfE:000000000000000000000000000000007WVX
X-Hashcash: 1:20:140603:linux-mm@kvack.org::ob1VzYuTwW6VM0c/:00000000000000000000000000000000000000000009kun
X-Hashcash: 1:20:140603:linux-kernel@vger.kernel.org::Z+x/CrA8IUfowyoP:000000000000000000000000000000000COn4
Date: Tue, 03 Jun 2014 09:00:48 +0200
Message-ID: <xa1twqcyjx3z.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03 2014, Joonsoo Kim wrote:
> Now, we have general CMA reserved area management framework,
> so use it for future maintainabilty. There is no functional change.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
> index dfb1dc9..ecb85ac 100644
> --- a/include/linux/dma-contiguous.h
> +++ b/include/linux/dma-contiguous.h
> @@ -53,9 +53,10 @@
>  
>  #ifdef __KERNEL__
>  
> +#include <linux/device.h>
> +

Why is this suddenly required?

>  struct cma;
>  struct page;
> -struct device;
>  
>  #ifdef CONFIG_DMA_CMA

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
