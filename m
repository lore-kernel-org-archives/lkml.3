Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaIZUEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:04:36 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42966 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaIZUEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:04:34 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mark Rustad <mark.d.rustad@intel.com>,
        "Kirsher\, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] include: kernel.h: deduplicate code implementing clamp* macros
In-Reply-To: <CAPh34mcT1tcWFO316+6dxAEhWc7MzLU0Uq3ATXv4N3cf9z5DHA@mail.gmail.com>
Organization: http://mina86.com/
References: <1410471576-12053-1-git-send-email-mina86@mina86.com> <1411660211-8303-1-git-send-email-mina86@mina86.com> <CAPh34mcT1tcWFO316+6dxAEhWc7MzLU0Uq3ATXv4N3cf9z5DHA@mail.gmail.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140926:rostedt@goodmis.org::uwZKASCCHdUICG2p:0000000000000000000000000000000000000000000FpO
X-Hashcash: 1:20:140926:hagen@jauu.net::8kARZKmODA1/YonR:0003X2n
X-Hashcash: 1:20:140926:mark.d.rustad@intel.com::7niZFjOYl4knTm69:000000000000000000000000000000000000004EFa
X-Hashcash: 1:20:140926:jeffrey.t.kirsher@intel.com::Ee6p1ie4nJ2Kes3Y:00000000000000000000000000000000006McA
X-Hashcash: 1:20:140926:linux-kernel@vger.kernel.org::K6IHOXPlh/iClhe3:0000000000000000000000000000000005utK
X-Hashcash: 1:20:140926:akpm@linux-foundation.org::zQX073WI6JZCi2pV:000000000000000000000000000000000000BAFh
Date: Fri, 26 Sep 2014 22:04:27 +0200
Message-ID: <xa1tvboaywqc.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25 2014, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> On 25 September 2014 17:50, Michal Nazarewicz <mina86@mina86.com> wrote:
>
>> - * @min: minimum allowable value
>> - * @max: maximum allowable value
>> + * @lo: minimum allowable value
>> + * @hi: maximum allowable value
>
> Ok, but why do you rename min/max to low/high after so many years?
> min/max is just perfect

To match argument names of the clamp macro (which got renamed when
rewriting min3, max3 and clamp), but I don't really care either way.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
