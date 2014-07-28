Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaG1KW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:22:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34772 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1KWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:22:52 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com
Subject: Re: [PATCH v2 1/3] usb: gadget: f_fs: virtual address mapping
In-Reply-To: <53D5E539.9030609@samsung.com>
Organization: http://mina86.com/
References: <1406295363-26998-1-git-send-email-r.baldyga@samsung.com> <1406295363-26998-2-git-send-email-r.baldyga@samsung.com> <xa1ttx65ttca.fsf@mina86.com> <53D5E539.9030609@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140728:balbi@ti.com::UDR5BdOMjd9Zs6uS:000000dwk
X-Hashcash: 1:20:140728:r.baldyga@samsung.com::RVkLauJt3UhBdvwx:00000000000000000000000000000000000000001jhj
X-Hashcash: 1:20:140728:linux-kernel@vger.kernel.org::fAhegZYxn1yjnI1s:0000000000000000000000000000000002n8M
X-Hashcash: 1:20:140728:m.szyprowski@samsung.com::wmogMIfR5QTZguRH:00000000000000000000000000000000000002TaP
X-Hashcash: 1:20:140728:andrzej.p@samsung.com::grqDhwYTHugcNUvZ:00000000000000000000000000000000000000002xAr
X-Hashcash: 1:20:140728:gregkh@linuxfoundation.org::ZnkI6FyJ0jvBHCZn:000000000000000000000000000000000004cDE
X-Hashcash: 1:20:140728:linux-usb@vger.kernel.org::6icU9HF3/eYgEZ1q:0000000000000000000000000000000000007mdV
Date: Mon, 28 Jul 2014 12:22:44 +0200
Message-ID: <xa1tk36xrde3.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> On 07/25/2014 04:18 PM, Michal Nazarewicz wrote:
>> On Fri, Jul 25 2014, Robert Baldyga wrote:
>>> This patch adds virtual endpoint address mapping to functionfs.
>>>
>>> So far endpoint addresses given by user through endpoint descriptors
>>> were ignored, and replaced by physical endpoint addresses. Endpoint
>>> address in wIndex field of setup requesti, addressed to endpoint, was
>>> the physical endpoint address, and names of files in functionfs
>>> directory was numered in order, and were the same as indexes of
>>> ffs_epfile in epfile array. In result user has no way to indicate
>>> which file in functionfs is associated with which particular
>>> requested endpoint. He also didn't know which endpoint is recipient
>>> of setup request.
>> 
>> Couldn't that be solved by simply providing the mapping to user space?
>
> There would be only small differences in code (add mapping instead of
> changing file names) so why would we not want do it in more intuitive
> way?

So I'm confused again.  With your patch, the endpoint number read from
user space will have barring *only* on the file name and it *will not*
correspond to the real/physical endpoint number, right?  Why do we want
that?  What's the advantage over having endpoints numbered in the order
they were specified?

To know what physical number endpoint has, user space would have to read
the descriptor via the new proposed ioctl or get a mapping from ep file
names to physical endpoint numbers.

>>> There was also one more problem - if endpoint addresses in descriptors
>>> were non-consecutive, there were created redundant files, which could
>>> cause problems in kernel, when user tryed to read/write to them.
>>> It was result of fact that maximum endpoint address was taken as
>>> total number of endpoints in funciton.
>> 
>> This is kinda unrelated though.  I mean it's a separate bug.
>
> Yes, but it can be fixed by the way, as a side effect, so there is no
> sense (and probably no simple way) to move it into separate patch.

Right, but now, we're arguing about the whole patch as opposed to having
part of it already acked. :P

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
