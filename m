Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3CAB2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:28:40 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56613 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3CAB2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130228155419.cf412612.akpm@linux-foundation.org>
References: <CAJd=RBBxTutPsF+XPZGt44eT1f0uPAQfCvQj_UmwdDg82J=F+A@mail.gmail.com>
 <1362029107-3908-2-git-send-email-kosaki.motohiro@gmail.com> <20130228155419.cf412612.akpm@linux-foundation.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 28 Feb 2013 20:28:19 -0500
Message-ID: <CAHGf_=rF2-2CBzEFg1am1+X0k4vDN2-jaR3bXWruSWeKHOK5iQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mempolicy: fix typo
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Dave Jones <davej@redhat.com>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 6:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 28 Feb 2013 00:25:07 -0500
> kosaki.motohiro@gmail.com wrote:
>
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Currently, n_new is wrongly initialized. start and end parameter
>> are inverted. Let's fix it.
>>
>> ...
>>
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -2390,7 +2390,7 @@ static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
>>
>>                               *mpol_new = *n->policy;
>>                               atomic_set(&mpol_new->refcnt, 1);
>> -                             sp_node_init(n_new, n->end, end, mpol_new);
>> +                             sp_node_init(n_new, end, n->end, mpol_new);
>>                               n->end = start;
>>                               sp_insert(sp, n_new);
>>                               n_new = NULL;
>
> huh.  What were the runtime effects of this problem?

I think passed policy don't effect correctly. No big issue because nobody
uses route except Dave Jones testcase. (remember, until very recently,
this route has kernel crash bug and nobody have been hit.)
