Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaJIK4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:56:49 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41511 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaJIK4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:56:40 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <Pine.LNX.4.44L0.1410081049400.1633-100000@iolanthe.rowland.org>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1410081049400.1633-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141009:linux-kernel@vger.kernel.org::Kc8nO8aaN13gX+rq:000000000000000000000000000000000028l
X-Hashcash: 1:20:141009:gregkh@linuxfoundation.org::rlKULha7tJekWD0A:000000000000000000000000000000000000IRd
X-Hashcash: 1:20:141009:r.baldyga@samsung.com::oD24qjqHcx+tmoXg:00000000000000000000000000000000000000000mEQ
X-Hashcash: 1:20:141009:k.opasiak@samsung.com::gJ9oHYoHId7rJI5I:00000000000000000000000000000000000000000OKu
X-Hashcash: 1:20:141009:linux-usb@vger.kernel.org::KblcJ1A4beS01zcs:0000000000000000000000000000000000001M3l
X-Hashcash: 1:20:141009:andrzej.p@samsung.com::w9y/JSdrUCBinATT:00000000000000000000000000000000000000002WaE
X-Hashcash: 1:20:141009:stern@rowland.harvard.edu::dnogRi73xlyUTAnz:0000000000000000000000000000000000003L8B
X-Hashcash: 1:20:141009:balbi@ti.com::64TMa0CFgsTr8pPe:000008yTn
Date: Thu, 09 Oct 2014 12:56:34 +0200
Message-ID: <xa1tr3yheckd.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Tue, Oct 07 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
>>> If you want to allow for the possibility of orderly shutdown (and maybe 
>>> even possible restart) of a userspace handler, the function library 
>>> should first tell the kernel explicitly to disconnect.

> On Tue, 7 Oct 2014, Michal Nazarewicz wrote:
>> I'm wondering if it would be possible to support user-space daemon
>> restarts with O_APPEND flag.  This is probably looking too far to the
>> future though.

On Wed, Oct 08 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
> Actually, we shouldn't need to consider the case where the descriptors
> change.  That _always_ requires a disconnect, and the user can cause
> a disconnect simply by killing the daemon and starting it again.  No
> separate restart capability is needed.

Correct.  This may be going a bit off-topic, but I was thinking of
a possible feature that would allow the daemon to indicate to kernel it
is ready to pick up the pieces after its previous instance crashed.
This would require the zombie mode to be implemented.

* Currently, once the daemon finishes or crashes, USB disconnect
  happens.

* In zombie mode, I could imagine the following scenarios:
  - daemon crashes, but the gadget still works, no disconnect happens;
  - daemon opens ep0 with O_APPEND, no disconnect happens;
  - daemon sends *the same* descriptors as before;
  - kernel recreates all the ep# files and let the daemon continue
    handling USB requests with host possibly never noticing.

Opening ep0 w/o O_APPEND or sending different descriptors would cause
a disconnect.  With the above, user-space would be able to force gadget
to disconnect by killing the daemon and then doing
    printf '' >/dev/functionfs/ep0
  
So I guess my point is that with zombie mode, user space could tell the
kernel to not-disconnect (rather than having an explicit disconnect
request) if it was written in a way that supports crash recovery.

This is a wishful thinking at this stage I guess, but perhaps it's worth
considering when deciding how the zombie interface should look like.
For example, I have some concerns if it should be enabled by an fs mount
option.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
