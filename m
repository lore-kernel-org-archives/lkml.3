Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3FYH0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:26:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62780 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3FYH0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:26:42 -0400
X-Spam-Score: -100.8
Message-ID: <51C945FE.2030305@asianux.com>
Date: Tue, 25 Jun 2013 15:25:50 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [Suggestion] arch: s390: mm: the warnings with allmodconfig and
 "EXTRA_CFLAGS=-W"
References: <51C8F685.6000209@asianux.com> <51C8F861.9010101@asianux.com> <20130625085006.01a7f368@mschwide>
In-Reply-To: <20130625085006.01a7f368@mschwide>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:50 PM, Martin Schwidefsky wrote:
> On Tue, 25 Jun 2013 09:54:41 +0800
> Chen Gang <gang.chen@asianux.com> wrote:
> 
>> > Hello Maintainers:
>> > 
>> > When allmodconfig for " IBM zSeries model z800 and z900"
>> > 
>> > It will report the related warnings ("EXTRA_CFLAGS=-W"):
>> >   mm/slub.c:1875:1: warning: ‘deactivate_slab’ uses dynamic stack allocation [enabled by default]
>> >   mm/slub.c:1941:1: warning: ‘unfreeze_partials.isra.32’ uses dynamic stack allocation [enabled by default]
>> >   mm/slub.c:2575:1: warning: ‘__slab_free’ uses dynamic stack allocation [enabled by default]
>> >   mm/slub.c:1582:1: warning: ‘get_partial_node.isra.34’ uses dynamic stack allocation [enabled by default]
>> >   mm/slub.c:2311:1: warning: ‘__slab_alloc.constprop.42’ uses dynamic stack allocation [enabled by default]
>> > 
>> > Is it OK ?
> Yes, these warnings should be ok. They are enabled by CONFIG_WARN_DYNAMIC_STACK,
> the purpose is to find all functions with dynamic stack allocations. The check
> if the allocations are truly ok needs to be done manually as the compiler
> can not find out the maximum allocation size automatically.

Thank you very much for your details information.

-- 
Chen Gang

Asianux Corporation
