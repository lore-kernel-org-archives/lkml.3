Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaKDNf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:35:26 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:59231 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaKDNfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:35:24 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Peter Hurley <peter@hurleysoftware.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: alloc_contig_range: demote pages busy message from warn to info
In-Reply-To: <5458C501.3040505@hurleysoftware.com>
Organization: http://mina86.com/
References: <2457604.k03RC2Mv4q@avalon> <1415033873-28569-1-git-send-email-mina86@mina86.com> <20141104054307.GA23102@bbox> <5458C501.3040505@hurleysoftware.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141104:linux-kernel@vger.kernel.org::e+PeiSyTMWpMmZ3i:0000000000000000000000000000000001JTv
X-Hashcash: 1:20:141104:laurent.pinchart@ideasonboard.com::1V1CjQ+sAWt6Flfr:000000000000000000000000000025xI
X-Hashcash: 1:20:141104:minchan@kernel.org::H49ybkTegpd5iN06:00000000000000000000000000000000000000000003jZT
X-Hashcash: 1:20:141104:akpm@linux-foundation.org::TvoLPIV7TWsMzxPz:0000000000000000000000000000000000003yNz
X-Hashcash: 1:20:141104:peter@hurleysoftware.com::/EYL3UgJd16jR5aQ:00000000000000000000000000000000000009Wpw
X-Hashcash: 1:20:141104:linux-mm@kvack.org::wUJbYcbxQij3DV7t:0000000000000000000000000000000000000000000BvWL
Date: Tue, 04 Nov 2014 14:35:19 +0100
Message-ID: <xa1tvbmv6qco.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04 2014, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 11/04/2014 12:43 AM, Minchan Kim wrote:
>> Hello,
>> 
>> On Mon, Nov 03, 2014 at 05:57:53PM +0100, Michal Nazarewicz wrote:
>>> Having test_pages_isolated failure message as a warning confuses
>>> users into thinking that it is more serious than it really is.  In
>>> reality, if called via CMA, allocation will be retried so a single
>>> test_pages_isolated failure does not prevent allocation from
>>> succeeding.
>>>
>>> Demote the warning message to an info message and reformat it such
>>> that the text “failed” does not appear and instead a less worrying
>>> “PFNS busy” is used.
>> 
>> What do you expect from this message? Please describe it so that we can
>> review below message helps your goal.
>
> I expect this message to not show up in logs unless there is a real problem.

So frankly I don't care.  Feel free to send a patch removing the message
all together.  I'll be happy to ack it.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
