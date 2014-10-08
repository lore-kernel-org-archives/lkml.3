Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaJHL2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:28:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48256 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaJHL2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:28:47 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Stanislaw Wadas <s.wadas@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <0ab101cfe2e0$030e6360$092b2a20$%opasiak@samsung.com>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org> <xa1toatny765.fsf@mina86.com> <0ab101cfe2e0$030e6360$092b2a20$%opasiak@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141008:balbi@ti.com::LKHXbwy0nddB5Ldu:000000m26
X-Hashcash: 1:20:141008:gregkh@linuxfoundation.org::m6/mR0IftBBce+eF:000000000000000000000000000000000001AMF
X-Hashcash: 1:20:141008:k.lewandowsk@samsung.com::gfZENpdFQpMNxxIa:00000000000000000000000000000000000001eEA
X-Hashcash: 1:20:141008:stern@rowland.harvard.edu::oMBb978iqrZ7OpeW:0000000000000000000000000000000000001b0v
X-Hashcash: 1:20:141008:linux-kernel@vger.kernel.org::RNju5ziMvq1151Db:0000000000000000000000000000000001cjq
X-Hashcash: 1:20:141008:andrzej.p@samsung.com::52OAzqg0BaPz6mNk:0000000000000000000000000000000000000000404F
X-Hashcash: 1:20:141008:k.opasiak@samsung.com::kBke95GJi/qcoFTB:00000000000000000000000000000000000000005bNa
X-Hashcash: 1:20:141008:linux-usb@vger.kernel.org::Tyv/EmFaSNIKTdN3:0000000000000000000000000000000000005TT8
X-Hashcash: 1:20:141008:r.baldyga@samsung.com::MB3L4BZZ018rDRwm:00000000000000000000000000000000000000005vBK
X-Hashcash: 1:20:141008:s.wadas@samsung.com::HyXBaYz9BAgXnbcg:000000000000000000000000000000000000000000D2hF
Date: Wed, 08 Oct 2014 13:28:41 +0200
Message-ID: <xa1tvbnussuu.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Mike Nazarewicz [mailto:mpn@google.com]
>> I don't really see that happening.  For the gadget to start all
>> descriptors need to be known.  Functionfs will know the descriptors
>> only once the user space daemon provides them.  Therefore, with the
>> current features (or even with addition of Robert's feature) there is
>> no way to let the gadget start without having the daemon running.

On Wed, Oct 08 2014, Krzysztof Opasiak <k.opasiak@samsung.com> wrote:
> Well, to be honest we do some lazy daemon startup in gadgetd. The idea
> is to provide functionality quite similar to inet. So we have divided
> functionfs services into two parts:
> - Descriptors - provided in configuration file
> - function implementation - provided in binary

Sure, and I'm not surprised to hear that has been implemented, but from
kernel point of view, the daemon is there and running.  Furthermore,
such behaviour is possible with or without the zombie feature, and in
fact kernel isn't able to prevent it, so it's immaterial to discussion
of the zombie feature.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
