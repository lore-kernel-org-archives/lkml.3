Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaJGUI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:08:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50061 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaJGUIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:08:24 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Cc: Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrzej.p@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141007:balbi@ti.com::MqwiPGXhM42xHUMY:000000lH5
X-Hashcash: 1:20:141007:andrzej.p@samsung.com::eowrEEnwVQsHM3Yo:000000000000000000000000000000000000000013R3
X-Hashcash: 1:20:141007:gregkh@linuxfoundation.org::kf1N63p6h3/q/8wd:0000000000000000000000000000000000031Jc
X-Hashcash: 1:20:141007:linux-usb@vger.kernel.org::j4/ifLrVMRTFIq9N:0000000000000000000000000000000000004bkc
X-Hashcash: 1:20:141007:r.baldyga@samsung.com::WoAWuhxagrMgXrMd:00000000000000000000000000000000000000005OuO
X-Hashcash: 1:20:141007:k.opasiak@samsung.com::sEnWuiNl9MAJWVGW:00000000000000000000000000000000000000008pBl
X-Hashcash: 1:20:141007:stern@rowland.harvard.edu::O/mmGhz8LxydqLU5:000000000000000000000000000000000000Dium
X-Hashcash: 1:20:141007:linux-kernel@vger.kernel.org::ok1W/bfFPUufmuDU:000000000000000000000000000000000E2XJ
Date: Tue, 07 Oct 2014 22:08:18 +0200
Message-ID: <xa1toatny765.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 7 Oct 2014, Felipe Balbi wrote:
>> Right, but if we allow this, I can already see folks abusing to
>> connect to the host early and only when necessary do some trickery to
>> e.g. start adbd (not saying Android will do this, just using it as an
>> easy example).

I don't really see that happening.  For the gadget to start all
descriptors need to be known.  Functionfs  will know the descriptors
only once the user space daemon provides them.  Therefore, with the
current features (or even with addition of Robert's feature) there is no
way to let the gadget start without having the daemon running.

On Tue, Oct 07 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
> We can still keep the pullup turned off until all the functions are
> ready.  That's a part of normal behavior -- unlike what happens when a
> userspace component crashes or is killed.

>> Then how do we differentiate a normal close() from a "oh-crap-I-died"
>> close() ?

> We can't, so why worry about it?

We actually might be able to distinguish those cases with another ioctl
which daemon must issue on the ep0 prior to closing it.  I'm not saying
that we should implement that though.

> If a file handle was closed for normal reasons then userspace probably 
> in the middle of shutting down the gadget anyway.  If not then the 
> user will get what they deserve.
>
> If the file handle was closed for abnormal reasons, we can behave like 
> crashed firmware.  Which means, in the end, doing the same thing as in 
> the normal-reason case -- i.e., do nothing.  In particular, don't 
> disconnect.
>
> If you want to allow for the possibility of orderly shutdown (and maybe 
> even possible restart) of a userspace handler, the function library 
> should first tell the kernel explicitly to disconnect.  Then function 
> components can be changed around completely, and when everything is 
> ready, userspace can tell the kernel to connect again.

I'm wondering if it would be possible to support user-space daemon
restarts with O_APPEND flag.  This is probably looking too far to the
future though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
