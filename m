Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3FGI4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:56:52 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:57838 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996Ab3FGI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:56:48 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51B1A04B.7030003@yandex-team.ru>
Date: Fri, 07 Jun 2013 12:56:43 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        yanmin.zhang@intel.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: slub: slab order on multi-processor machines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

While investigating some compaction-related problems, I noticed, that many (even most)
kernel objects are allocated on slabs with order 2 or 3.

This behavior was introduced by commit 9b2cd506e "slub: Calculate min_objects based on
number of processors." by Christoph Lameter.
As I understand, the idea was to make kernel allocations cheaper by reducing the total
number of page allocations (allocating 1 page with order 3 is cheaper than allocating
8 1-ordered pages).

I'm sure, it's true for recently rebooted machine with a lot of free non-fragmented memory.
But is it also true for heavy-loaded machine with fragmented memory?
Are we sure, that it's cheaper to run compaction and allocate order 3 page than to use
small 1-pages slabs?
Do I miss something?

Disabling this behavior dramatically reduces the number of 2- and 3-ordered allocations.
Compaction is performed significantly rarer. This is especially noticeable on machines
with intensive disk i/o. I do not see any performance degradation. But I'm not sure,
that I'm not missing something.

Any comments and/or ideas are welcomed.

Thanks!

Regards,
Roman
