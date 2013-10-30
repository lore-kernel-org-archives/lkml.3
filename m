Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3J3SoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:44:12 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:10651 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189Ab3J3SoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:44:11 -0400
Message-ID: <52715379.3020808@akamai.com>
Date: Wed, 30 Oct 2013 14:44:09 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
References: <20131030180042.7db60252a0779f89483ef51b@canb.auug.org.au>
In-Reply-To: <20131030180042.7db60252a0779f89483ef51b@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 03:00 AM, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/linux/init.h:4:0,
>                  from fs/eventpoll.c:14:
> fs/eventpoll.c: In function 'eventpoll_init':
> include/linux/compiler.h:321:20: error: call to '__compiletime_assert_2137' declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <= 8 && sizeof(struct epitem) > 128
>     prefix ## suffix();    \

Yes, my fault for not compiling on more arches - I've posted a fix for this today as:

Subject: [PATCH] epoll: remove the on_list check for 'struct epitem'

Thanks,

-Jason
