Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaJFOHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:07:37 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:45909 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaJFOHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:07:35 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        k.opasiak@samsung.com
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <5432903A.9070907@samsung.com>
Organization: http://mina86.com/
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com> <xa1tvbnx2x4w.fsf@mina86.com> <5432903A.9070907@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141006:gregkh@linuxfoundation.org::JRJCbVQNg8iW7v+u:000000000000000000000000000000000000dy2
X-Hashcash: 1:20:141006:linux-usb@vger.kernel.org::TSs4JIOkp+BiddTp:0000000000000000000000000000000000001ZOr
X-Hashcash: 1:20:141006:balbi@ti.com::kEOlbtv0L6WD65Ga:000004RoM
X-Hashcash: 1:20:141006:r.baldyga@samsung.com::CmWijeXo40yRcpyf:00000000000000000000000000000000000000006CcF
X-Hashcash: 1:20:141006:k.opasiak@samsung.com::vGzkJpOQjJDKBc7g:0000000000000000000000000000000000000000602p
X-Hashcash: 1:20:141006:andrzej.p@samsung.com::JrCEqrQRMQVlZN3R:000000000000000000000000000000000000000065Z4
X-Hashcash: 1:20:141006:linux-kernel@vger.kernel.org::QB6DpfXlUJuoIni1:000000000000000000000000000000000B8wI
Date: Mon, 06 Oct 2014 16:07:29 +0200
Message-ID: <xa1tppe52swu.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 10/06/2014 02:36 PM, Michal Nazarewicz wrote:
>> However, all the ep# files will still exist on the filesystem.  This may
>> be a bit confusing and error-prone, no?

On Mon, Oct 06 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> Shouldn't be error-prone, because opening them will fail with -ENODEV,
> but indeed it can be confusing. I will try to do something about that

I could imagine someone will write shell script like so:

	ffs_active() {
		test -d "$1" || return 1
		set -- "$1"/ep*
		test $# -gt 1
	}

	if ffs_active /dev/foo-ffs; then
		# …
	fi

With such a script, non-functional ep# files in the functionfs mount
point, could lead to some errors in user-space.  I'm not saying that
this should block on any kind of changes to the way the filesystem works
when the function is inactive, but if possible, w/o a lot of additional
code, I'd rather if all the files disappeared in a zombie state.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
