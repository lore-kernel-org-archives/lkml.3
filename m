Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbaGNPZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:25:55 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61469 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaGNPZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:25:47 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gioh Kim <gioh.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
In-Reply-To: <20140714070225.GE11317@js1304-P5Q-DELUXE>
Organization: http://mina86.com/
References: <53B664E5.5060102@lge.com> <20140707155252.15e81dff6683393ba3590478@linux-foundation.org> <xa1tpphf4x3s.fsf@mina86.com> <20140714070225.GE11317@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140714:linux-fsdevel@vger.kernel.org::Jc1rW0YPDzu+c3uJ:0000000000000000000000000000000005PY
X-Hashcash: 1:20:140714:m.szyprowski@samsung.com::1ujrkM/AOytZnCiI:00000000000000000000000000000000000000J19
X-Hashcash: 1:20:140714:iamjoonsoo.kim@lge.com::58HalT869n82DJoo:0000000000000000000000000000000000000000b/2
X-Hashcash: 1:20:140714:linux-kernel@vger.kernel.org::yXnzh7woY0uT1wXd:0000000000000000000000000000000001vZZ
X-Hashcash: 1:20:140714:gurugio@gmail.com::iJZHIDjFTmM8IQy/:0000000000000000000000000000000000000000000025rF
X-Hashcash: 1:20:140714:akpm@linux-foundation.org::1ZSVlRh0E3sWI7o1:0000000000000000000000000000000000001iIu
X-Hashcash: 1:20:140714:lauraa@codeaurora.org::bVCo7ZgD2QZjVhUt:0000000000000000000000000000000000000000257v
X-Hashcash: 1:20:140714:gioh.kim@lge.com::5vyF9OQ9KKiUUouR:06kws
X-Hashcash: 1:20:140714:gunho.lee@lge.com::L85eQ0yAnCdmXhAR:000000000000000000000000000000000000000000005yb2
X-Hashcash: 1:20:140714:viro@zeniv.linux.org.uk::cFZ8pybIkY5fK3qf:00000000000000000000000000000000000000EYOm
Date: Mon, 14 Jul 2014 17:25:41 +0200
Message-ID: <xa1t4mykarnu.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> On Tue, Jul 08, 2014 at 06:46:31PM +0200, Michal Nazarewicz wrote:
>> This seems reasonable, except I think [invalidate_bh_lrus()] should
>> go after start_isolate_page_range call because otherwise there's no
>> guarantee that someone won't grab those pages back.
>> 
>> Also to avoid the #ifdef perhaps we want this as well:
>
> I think that we just want to remove ifdef CONFIG_CMA on above code
> snippet, because invalidate_bh_lrus() would also help user of
> alloc_contig_range() with MIGRATE_MOVABLE.

Sounds good to me.

>> The purpose is to get free non-buddy pages (so pages on PCP lists for
>> instance) back onto the buddy list.  It's safe to move those calls above
>> the call to __alloc_contig_migrate_range, but I don't think it will
>> change anything (except of course the fact that if migration fails,
>> we'll do the draining for nothing).

> At a glance, we don't need that drain_all_pages(), because
> drain_all_pages() is also called by set_migratetype_isolate() after
> changing migratetype.

You are likely correct.

> And, it is better to move up lru_add_drain_all() to ahead of
> __alloc_contig_migrate_range(), because some pages could be skipped
> to migrate due to this lru page caching mechanism.

Again, sounds good to me.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
