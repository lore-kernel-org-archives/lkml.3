Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3BZLjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:39:07 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54397 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab3BZLjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <512C15F0.6030907@oracle.com>
References: <512B677D.1040501@oracle.com>
	<CAHGf_=rur29gFs9R9AYeDwnbVBm3b3cOfAn2xyi=mQ+ZbgzEDA@mail.gmail.com>
	<512C15F0.6030907@oracle.com>
Date: Tue, 26 Feb 2013 19:39:03 +0800
Message-ID: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
Subject: Re: mm: BUG in mempolicy's sp_insert
From: Hillf Danton <dhillf@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 9:54 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 02/25/2013 08:52 PM, KOSAKI Motohiro wrote:
>> On Mon, Feb 25, 2013 at 8:30 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> Hi all,
>>>
>>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
>>> I've stumbled on the following BUG:
>>>
>>> [13551.830090] ------------[ cut here ]------------
>>> [13551.830090] kernel BUG at mm/mempolicy.c:2187!
>>> [13551.830090] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>
>> Unfortunately, I didn't reproduce this. I'll try it tonight.
>
> I've actually managed to reproduce it again since then, so it's not a one time
> fluke (which is a good sign a I guess).
>
> It did require about an hour of fuzzing just mm with trinity.
>
Insert new node after updating node in tree.

Hillf

--- a/mm/mempolicy.c	Tue Feb 26 19:33:20 2013
+++ b/mm/mempolicy.c	Tue Feb 26 19:35:38 2013
@@ -2391,8 +2391,8 @@ restart:
 				*mpol_new = *n->policy;
 				atomic_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, n->end, end, mpol_new);
-				sp_insert(sp, n_new);
 				n->end = start;
+				sp_insert(sp, n_new);
 				n_new = NULL;
 				mpol_new = NULL;
 				break;
--
