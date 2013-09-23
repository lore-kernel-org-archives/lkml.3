Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3IWJ3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:29:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44043 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3IWJ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:29:17 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-08-524009eb6912
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] perf callchain: Convert children list to rbtree
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
	<1378801458-2515-2-git-send-email-namhyung@kernel.org>
	<20130922111559.GC1036@krava.brq.redhat.com>
Date: Mon, 23 Sep 2013 18:29:15 +0900
In-Reply-To: <20130922111559.GC1036@krava.brq.redhat.com> (Jiri Olsa's message
	of "Sun, 22 Sep 2013 13:15:59 +0200")
Message-ID: <87zjr3q42c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 22 Sep 2013 13:15:59 +0200, Jiri Olsa wrote:
> On Tue, Sep 10, 2013 at 05:24:16PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>
> SNIP
>
>> index 2b585bc308cf..1b22b6269213 100644
>> --- a/tools/perf/util/callchain.h
>> +++ b/tools/perf/util/callchain.h
>> @@ -21,10 +21,9 @@ enum chain_order {
>>  
>>  struct callchain_node {
>>  	struct callchain_node	*parent;
>> -	struct list_head	siblings;
>> -	struct list_head	children;
>>  	struct list_head	val;
>>  	struct rb_node		rb_node; /* to sort nodes in an rbtree */
>> +	struct rb_root		rb_root_in; /* sorted tree of children */
>>  	struct rb_root		rb_root; /* sorted tree of children */
>>  	unsigned int		val_nr;
>>  	u64			hit;
>> @@ -86,8 +85,6 @@ extern __thread struct callchain_cursor callchain_cursor;
>>  
>>  static inline void callchain_init(struct callchain_root *root)
>>  {
>> -	INIT_LIST_HEAD(&root->node.siblings);
>> -	INIT_LIST_HEAD(&root->node.children);
>>  	INIT_LIST_HEAD(&root->node.val);
>
> don't we miss rb_root_in init here, like:
>
> 	root->node.rb_root_in = RB_ROOT;

The struct callchain_root in hist entry initialized to zero so
technically it doesn't need to be set.  But I think it's better to have
explicit initializer.

Thanks,
Namhyung
