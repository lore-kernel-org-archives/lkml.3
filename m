Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbaGYOSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:18:36 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53398 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760468AbaGYOSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:18:33 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v2 1/3] usb: gadget: f_fs: virtual address mapping
In-Reply-To: <1406295363-26998-2-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com> <1406295363-26998-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140725:linux-kernel@vger.kernel.org::ZF1h3BGDEHG4U27b:0000000000000000000000000000000000nxk
X-Hashcash: 1:20:140725:m.szyprowski@samsung.com::mx9PFxLBIsuLkqsh:00000000000000000000000000000000000000n0q
X-Hashcash: 1:20:140725:gregkh@linuxfoundation.org::4kr0dqIQofOLC8MH:000000000000000000000000000000000001deH
X-Hashcash: 1:20:140725:balbi@ti.com::tHCF81/GrgoOWLff:000001rIa
X-Hashcash: 1:20:140725:linux-usb@vger.kernel.org::Of3qlxmP7Y+I4IL2:0000000000000000000000000000000000003MLy
X-Hashcash: 1:20:140725:r.baldyga@samsung.com::CjibNel2sheZ85E6:00000000000000000000000000000000000000002a9H
X-Hashcash: 1:20:140725:andrzej.p@samsung.com::osQxGPAYe+WjkwqS:0000000000000000000000000000000000000000DMP6
X-Hashcash: 1:20:140725:r.baldyga@samsung.com::xjFyMSY+GWNdOTUS:0000000000000000000000000000000000000000Fh/5
Date: Fri, 25 Jul 2014 16:18:29 +0200
Message-ID: <xa1ttx65ttca.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25 2014, Robert Baldyga wrote:
> This patch adds virtual endpoint address mapping to functionfs.
>
> So far endpoint addresses given by user through endpoint descriptors
> were ignored, and replaced by physical endpoint addresses. Endpoint
> address in wIndex field of setup requesti, addressed to endpoint, was
> the physical endpoint address, and names of files in functionfs
> directory was numered in order, and were the same as indexes of
> ffs_epfile in epfile array. In result user has no way to indicate
> which file in functionfs is associated with which particular
> requested endpoint. He also didn't know which endpoint is recipient
> of setup request.

Couldn't that be solved by simply providing the mapping to user space?

> There was also one more problem - if endpoint addresses in descriptors
> were non-consecutive, there were created redundant files, which could
> cause problems in kernel, when user tryed to read/write to them.
> It was result of fact that maximum endpoint address was taken as
> total number of endpoints in funciton.

This is kinda unrelated though.  I mean it's a separate bug.

> This patch solves this problems by introducing virtual endpoint address
> mapping. Now each function has separate endpoint address space. Numbers
> of endpoint files in functionfs and addresses in setup requests are
> mapped to addresses choosen by user in endpoint descriptors.
>
> It also introduces additional testing if desctiptors given by user are
> consistent - if number of endpoints and their addresses in each speed
> are the same.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/f_fs.c | 78 +++++++++++++++++++++++++++++++++++++++--------
>  drivers/usb/gadget/u_fs.h |  2 ++
>  2 files changed, 68 insertions(+), 12 deletions(-)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
