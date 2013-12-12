Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3LLMCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:02:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3LLMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:02:09 -0500
X-AuditID: cbfee691-b7fd26d000003f7b-6b-52a9a5bf3c51
From: Kyungmin Park <kyungmin.park@samsung.com>
To: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Ingo Molnar'" <mingo@redhat.com>
References: <1386847772-8918-1-git-send-email-andrzej.p@samsung.com>
 <20131212113511.GG21999@twins.programming.kicks-ass.net>
In-reply-to: <20131212113511.GG21999@twins.programming.kicks-ass.net>
Subject: RE: [PATCH v2] kernel/locking: mutex: simplify access to the first
 entry in the wait-list
Date: Thu, 12 Dec 2013 21:02:07 +0900
Message-id: <23bd01cef731$fb052680$f10f7380$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac73Lj6IRVO1gU/aR7iriNY5wWSdEAAA5aSA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zLd39S1cGGRy9Jm8x62U7i8XlXXPY
	LNYeuctucenAAiaL470HmBxYPTav0PJ4v+8qm0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	XGs/zFJwiqPiyd8fTA2M39m6GDk4JARMJOZ9yu9i5AQyxSQu3FsPFObiEBJYxijxfe0fZoiE
	icS/e39YQWwhgemMEqdOJUMU/WWUeHDjIBNIgk1AX2LHtPXsILaIQJxE+46FjCA2s0CxxNqV
	S5ghmuslzve9ABvEKeAqsfkkRL2wQIrEnO+fwOpZBFQlvjw7xgJi8wrYSXw6Po8ZwhaU+DH5
	HgvETC2J9TuPM0HY8hKb17xlhnhGXeLRX12IE4wknn7+BVUuIrHvxTtGkJslBM6xS9xaeIId
	YpeAxLfJh1ggemUlNh2A+ldS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQi
	U73ixNzi0rx0veT83E2MkNicuIPx/gHrQ4zJQOsnMkuJJucDYzuvJN7Q2MzIwtTE1NjI3NKM
	NGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgnO/rtS52ev3XHvTv7ks69cM4M
	Ez/9KTErUC7r3IsWA83LNi/yXoaGdicpLz16Myd281mNzLKs7+2nOfaf9jotGHl+Xbez8TV+
	K+f1+rcnWQvVLWD8FD3houEy42SnRUxHhKpaTk++yNy42DVyzd33jU1CjF77vJLT7UJ+Fjoq
	HP+6tOwjj4kSS3FGoqEWc1FxIgBIYHfS4wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd39S1cGGZw7J20x62U7i8XlXXPY
	LNYeuctucenAAiaL470HmBxYPTav0PJ4v+8qm0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZlxrP8xScIqj4snfH0wNjN/Zuhg5OSQETCT+3fvDCmGL
	SVy4tx4sLiQwnVHi1KnkLkYuIPsvo8SDGweZQBJsAvoSO6atZwexRQTiJNp3LGQEsZkFiiXW
	rlzCDNFcL3G+7wXYUE4BV4nNJyHqhQVSJOZ8/wRWzyKgKvHl2TEWEJtXwE7i0/F5zBC2oMSP
	yfdYIGZqSazfeZwJwpaX2LzmLVANB9Ch6hKP/upCnGAk8fTzL6hyEYl9L94xTmAUmoVk0iwk
	k2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGx/0x6B+OqBotDjAIcjEo8
	vC8OrggSYk0sK67MPcQowcGsJMLrkroySIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgWkp
	ryTe0NjEzMjSyMzYxNzYmDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYg6oUYjjqKwOs
	9W6sbJhy9+6XzY2FR5Iu/F8Q5ni4JOzGGoX3m3X+P7Z22hvdkzjLc+PGiQ1XpKylohcyXU1m
	+N2YXn/owgQ+zQ37HVgqj664df/3C+Hddh08y+P+SL740JtdvSDSWy0xJE9KTlzdsVt6xoVn
	F1TCEmfYBe/Pt0/IPqFkKOujxFKckWioxVxUnAgAA+CmZUEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Thursday, December 12, 2013 8:35 PM
> To: Andrzej Pietrasiewicz
> Cc: linux-kernel@vger.kernel.org; Kyungmin Park; Marek Szyprowski; Ingo
> Molnar
> Subject: Re: [PATCH v2] kernel/locking: mutex: simplify access to the
> first entry in the wait-list
> 
> On Thu, Dec 12, 2013 at 12:29:32PM +0100, Andrzej Pietrasiewicz wrote:
> > Use list_first_entry instead of explicitly accessing the first entry
> > with "head".next. The comment one line above becomes obsolete.
> >
> > Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >
> > v1..v2:
> >
> > - corrected the email address in the second Signed-off-by line
> 
> Still invalid; the problem is that you appear to have written the patch
> (you send it and you have first sob).


> So what is Kyungmin doing in the line? He did not send me your patch.

Internal review process, and it represents this patch comes from.

Thank you,
Kyungmin Park

