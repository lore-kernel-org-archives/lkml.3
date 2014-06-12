Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbaFLJzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:55:17 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:45824 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942AbaFLJzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:55:13 -0400
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
Subject: Re: [PATCH v2 03/10] DMA, CMA: separate core cma management codes from DMA APIs
In-Reply-To: <1402543307-29800-4-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::jU5HRkbXRqMsA53X:0000000000000000000000000000000000000000000IPI
X-Hashcash: 1:20:140612:agraf@suse.de::SLLXO9dyRUClqWj0:00000NrR
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::QkPYsj4PvZKUMHtz:0000000000000000000000000000000000000000fKP
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::RU1DrNK/0cy2/Z93:0000000000000000000000000000000000000epR
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::ZY7W1qjfDHlKxJ80:0000000000000000000000000000000000000000x1b
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::nuMD7/kUPpFxcQFw:0000000000000000000000000000000000000001iNl
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::pDurYJFXGej+hzGc:00000000000000000000000000000000000001zVz
X-Hashcash: 1:20:140612:pbonzini@redhat.com::a7R6fPFdzhimyqLZ:0000000000000000000000000000000000000000002Seb
X-Hashcash: 1:20:140612:paulus@samba.org::DvcwOHwVc6ku6rhq:02moU
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::zjJJNZNSWl6wRFjs:00000000000000000000000002PM3
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::6tD3ube7LTXtPPaY:0000000000000000000000000000000003Z8h
X-Hashcash: 1:20:140612:linux-mm@kvack.org::KpZQmK2i/Wb+S1wX:000000000000000000000000000000000000000000041VD
X-Hashcash: 1:20:140612:gleb@kernel.org::6CYblcQsIjV3+z0P:004bRe
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::97xIr6GmStCtclS/:000000000000000000000000000000005aE2
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::vL1WxSC9u5RAdLZ2:00000000000000000000000000000071CQ
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::S8JF9hHpz6behSxR:00000000000000000000000000000000000000780a
X-Hashcash: 1:20:140612:minchan@kernel.org::npMuXZF+qEXEsK6D:0000000000000000000000000000000000000000000CP3T
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::zDUusIjujGadY95h:00000000000000000000000000000000000Isz7
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::v/rtzONrpxvozYcx:0000000000000000000000000000000000000KWAM
Date: Thu, 12 Jun 2014 11:55:09 +0200
Message-ID: <xa1tbntyjvuq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> To prepare future generalization work on cma area management code,
> we need to separate core cma management codes from DMA APIs.
> We will extend these core functions to cover requirements of
> ppc kvm's cma area management functionality in following patches.
> This separation helps us not to touch DMA APIs while extending
> core functions.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
