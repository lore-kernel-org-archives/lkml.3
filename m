Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbaFYW20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:28:26 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:45123 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbaFYW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:28:24 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] lib: list_sort: Various minor improvements
Organization: D03
References: <1403604392-23259-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140625145314.3e16af6998765b7aad860bf7@linux-foundation.org>
X-Hashcash: 1:20:140625:linux-kernel@vger.kernel.org::wNBdyzNP8Ni2ib9d:0000000000000000000000000000000000kpl
X-Hashcash: 1:20:140625:david@fromorbit.com::oGEq8vc5QYZvSAgM:0000000000000000000000000000000000000000000qFS
X-Hashcash: 1:20:140625:akpm@linux-foundation.org::TLxzck2HAkhsNazD:0000000000000000000000000000000000007QcH
X-Hashcash: 1:20:140625:artem.bityutskiy@linux.intel.com::AuGaHXNqo7K2uaUs:000000000000000000000000000005PUY
X-Hashcash: 1:20:140625:don.mullis@gmail.com::XuErPmZbwtS3EVxV:000000000000000000000000000000000000000007Xfj
Date: Thu, 26 Jun 2014 00:28:18 +0200
In-Reply-To: <20140625145314.3e16af6998765b7aad860bf7@linux-foundation.org>
	(Andrew Morton's message of "Wed, 25 Jun 2014 14:53:14 -0700")
Message-ID: <87egycoc8t.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 24 Jun 2014 12:06:27 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>
>> Reading the source of lib/list_sort.c, I came up with a few possible
>> improvements. I think 4/4 may be a bit controversial, but 1/4, 2/4 and
>> 3/4 should be straightforward.
>> 
>
> All looks OK to me.

Thanks.

> We may as well do the pr_foo() conversion as well.  As often happens,
> the results are quite pleasing.
>
> --- a/lib/list_sort.c~lib-list_sortc-convert-to-pr_foo
> +++ a/lib/list_sort.c
> @@ -1,3 +1,6 @@
> +
> +#define pr_fmt(fmt) "list_sort_test: " fmt
> +
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/list_sort.h>
> @@ -125,9 +128,8 @@ void list_sort(void *priv, struct list_h
>  		}
>  		if (lev > max_lev) {
>  			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
> -				printk_once(KERN_DEBUG "list passed to"
> -					" list_sort() too long for"
> -					" efficiency\n");
> +				pr_debug_once("list passed to list_sort() too "
> +					      "long for efficiency\n");

Minor comment: Won't this end up saying "list_sort_test: list passed to
...", despite the list coming from a 'real' user? Maybe change the first
#define to '"list_sort: " fmt', the above message to "passed list too
long for efficiency", and redefine pr_fmt right after #ifdef
CONFIG_TEST_LIST_SORT.

Rasmus
