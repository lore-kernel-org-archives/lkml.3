Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaFKIZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:25:08 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40554 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaFKIZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:25:00 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 2/3] DMA, CMA: use general CMA reserved area management framework
In-Reply-To: <20140610024910.GB19036@js1304-P5Q-DELUXE>
Organization: http://mina86.com/
References: <1401757919-30018-1-git-send-email-iamjoonsoo.kim@lge.com> <1401757919-30018-3-git-send-email-iamjoonsoo.kim@lge.com> <xa1twqcyjx3z.fsf@mina86.com> <20140610024910.GB19036@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140611:linuxppc-dev@lists.ozlabs.org::Z2pZYlzJo9SwcoPb:0000000000000000000000000000000000DA
X-Hashcash: 1:20:140611:linux-mm@kvack.org::KwrON1EEY661Mh2s:00000000000000000000000000000000000000000000AbL
X-Hashcash: 1:20:140611:linux@arm.linux.org.uk::rfJYa6LoEFeLlXMc:0000000000000000000000000000000000000000I8L
X-Hashcash: 1:20:140611:m.szyprowski@samsung.com::3TxLwY7ow1yDMBgF:00000000000000000000000000000000000000SrH
X-Hashcash: 1:20:140611:linux-kernel@vger.kernel.org::J4OLA2eefPclA6z3:0000000000000000000000000000000000v4A
X-Hashcash: 1:20:140611:kvm-ppc@vger.kernel.org::+rnLcQzdVinxMJ83:000000000000000000000000000000000000001JuW
X-Hashcash: 1:20:140611:linux-arm-kernel@lists.infradead.org::N+62UNPw+v0Jf0wL:00000000000000000000000001cHx
X-Hashcash: 1:20:140611:kvm@vger.kernel.org::uJ8WPKQw7xQGNEZS:0000000000000000000000000000000000000000001lAn
X-Hashcash: 1:20:140611:agraf@suse.de::/D7Sns2QQ+Kl33q/:00002JPl
X-Hashcash: 1:20:140611:minchan@kernel.org::Hj30c+qIXEiM6hAC:00000000000000000000000000000000000000000002FJ5
X-Hashcash: 1:20:140611:gregkh@linuxfoundation.org::+FSzsno473eikgDH:000000000000000000000000000000000002LU0
X-Hashcash: 1:20:140611:aneesh.kumar@linux.vnet.ibm.com::5/tFi6Gpl3a98Crs:0000000000000000000000000000002OtM
X-Hashcash: 1:20:140611:iamjoonsoo.kim@lge.com::4zonU8vPlo3bTBNP:0000000000000000000000000000000000000002b2j
X-Hashcash: 1:20:140611:akpm@linux-foundation.org::BcxLR4fuH+7yI4i1:0000000000000000000000000000000000003KCu
X-Hashcash: 1:20:140611:benh@kernel.crashing.org::x5mOBqxdS7868yJ7:00000000000000000000000000000000000003A2d
X-Hashcash: 1:20:140611:gleb@kernel.org::mfeB3esWQRFrXiG2:006vS4
X-Hashcash: 1:20:140611:paulus@samba.org::BlRYvaSeoIFoo9ii:071IQ
X-Hashcash: 1:20:140611:pbonzini@redhat.com::Lb6Uy0L/g9FRF691:0000000000000000000000000000000000000000008SVB
Date: Wed, 11 Jun 2014 10:24:55 +0200
Message-ID: <xa1t38fb3lbc.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Without including device.h, build failure occurs.
> In dma-contiguous.h, we try to access to dev->cma_area, so we need
> device.h. In the past, we included it luckily by swap.h in
> drivers/base/dma-contiguous.c. Swap.h includes node.h and then node.h
> includes device.h, so we were happy. But, in this patch, I remove
> 'include <linux/swap.h>' so we need to include device.h explicitly.

Ack.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
