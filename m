Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaG1PWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:22:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60196 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaG1PWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:22:03 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 1/3] usb: gadget: f_fs: virtual address mapping
In-Reply-To: <53D6397F.50403@samsung.com>
Organization: http://mina86.com/
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com> <1406295363-26998-2-git-send-email-r.baldyga@samsung.com> <xa1ttx65ttca.fsf@mina86.com> <53D5E539.9030609@samsung.com> <xa1tk36xrde3.fsf@mina86.com> <53D6397F.50403@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140728:m.szyprowski@samsung.com::oLRYw3BjiLD4N6bY:00000000000000000000000000000000000000RcD
X-Hashcash: 1:20:140728:r.baldyga@samsung.com::574O06XgcqDzk9GT:00000000000000000000000000000000000000000nbN
X-Hashcash: 1:20:140728:balbi@ti.com::ZHLv97C6f+PaMxlv:000001LbK
X-Hashcash: 1:20:140728:linux-kernel@vger.kernel.org::JmVh2Z+18H8QrAJ0:00000000000000000000000000000000018JY
X-Hashcash: 1:20:140728:andrzej.p@samsung.com::G88UW+WyLOYKMYdM:00000000000000000000000000000000000000001iK2
X-Hashcash: 1:20:140728:gregkh@linuxfoundation.org::OhjHeb4FjcQ1Z1bX:0000000000000000000000000000000000036n8
X-Hashcash: 1:20:140728:linux-usb@vger.kernel.org::hZe4HxDfpTfXLARH:0000000000000000000000000000000000002e01
Date: Mon, 28 Jul 2014 17:21:54 +0200
Message-ID: <xa1t7g2xqzjh.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I see, I misunderstood your change before.  So what you're saying is
that now we have:
1. numbers user space provides in bEndpoindAddress,
2. physical addresses assigned when endpoint is configured, and
3. numbers for file names which go sequentially;
and what you want is to change the code so that 1 and 3 are the same.

Yes, I agree that would be better, and it was quite an omission on my
part that I did not implement it that way, but at this point, I would
argue that breaking backwards compatibility is not really worth it.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
