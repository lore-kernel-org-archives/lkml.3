Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaFLLeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:34:36 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38570 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbaFLLec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:34:32 -0400
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
Subject: Re: [PATCH v2 08/10] mm, cma: clean-up cma allocation error path
In-Reply-To: <1402543307-29800-9-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-9-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::4HjonQ+qYoMejd70:0000000000000000000000000000000000000006L/
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::SM3O3w8BUSGRQkg2:0000000000000000000000000000000000000000000CwL
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::K5EnRUaJuGgSr1jS:0000000000000000000000000000000000RDh
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::qeBcI0erflsKQpzu:0000000000000000000000000000000000000000iLt
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::Q/DB85n4xVTWzJtn:0000000000000000000000000000000000000000uBL
X-Hashcash: 1:20:140612:linux-mm@kvack.org::2OmkgaQ8l3kyurgT:0000000000000000000000000000000000000000000185K
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::xWeDThF/8bfodDcP:00000000000000000000000000000000000001FHz
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::Go8fjXe/DAztFs+b:0000000000000000000000000000001HBz
X-Hashcash: 1:20:140612:agraf@suse.de::bv9yRO/H7p/C2zAp:00001M5G
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::FYHTD9M0O3IXYHCC:00000000000000000000000000000000000001N8G
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::3/WRmNYhlznjeASk:000000000000000000000000000000000001v5j
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::iTa8+FHZILjFZwzx:0000000000000000000000000000000000003SfZ
X-Hashcash: 1:20:140612:minchan@kernel.org::qjjJXDfZ+nUR5eUH:000000000000000000000000000000000000000000038v2
X-Hashcash: 1:20:140612:pbonzini@redhat.com::OhuF5fQ0/tkjgodp:0000000000000000000000000000000000000000003a/+
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::kowEHUTSuFzbbNn3:000000000000000000000000000000006el7
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::LbxmIWbMwzzPOoan:00000000000000000000000006yIF
X-Hashcash: 1:20:140612:gleb@kernel.org::TQT0QmHbyK2CRGvI:0079bF
X-Hashcash: 1:20:140612:paulus@samba.org::OQIG2UKEwuTKJCk/:07wYR
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::CWLrn6gHBd2AyxkK:0000000000000000000000000000000000000008mCD
Date: Thu, 12 Jun 2014 13:34:27 +0200
Message-ID: <xa1tzjhiicos.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> We can remove one call sites for clear_cma_bitmap() if we first
> call it before checking error number.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/mm/cma.c b/mm/cma.c
> index 1e1b017..01a0713 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -282,11 +282,12 @@ struct page *cma_alloc(struct cma *cma, int count, unsigned int align)
>  		if (ret == 0) {
>  			page = pfn_to_page(pfn);
>  			break;
> -		} else if (ret != -EBUSY) {
> -			clear_cma_bitmap(cma, pfn, count);
> -			break;
>  		}
> +
>  		clear_cma_bitmap(cma, pfn, count);
> +		if (ret != -EBUSY)
> +			break;
> +
>  		pr_debug("%s(): memory range at %p is busy, retrying\n",
>  			 __func__, pfn_to_page(pfn));
>  		/* try again with a bit different memory target */

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
