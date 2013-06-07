Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3FGRJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:09:40 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:55421 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab3FGRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:09:38 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51B213CB.8070102@yandex-team.ru>
Date: Fri, 07 Jun 2013 21:09:31 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: penberg@kernel.org, mpm@selenic.com, yanmin.zhang@intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: slub: slab order on multi-processor machines
References: <51B1A04B.7030003@yandex-team.ru> <0000013f1efbaa4f-6039ad3e-286e-4486-8b7e-7b0331edf990-000000@email.amazonses.com>
In-Reply-To: <0000013f1efbaa4f-6039ad3e-286e-4486-8b7e-7b0331edf990-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.06.2013 18:12, Christoph Lameter wrote:
> On Fri, 7 Jun 2013, Roman Gushchin wrote:
>
>> As I understand, the idea was to make kernel allocations cheaper by reducing
>> the total
>> number of page allocations (allocating 1 page with order 3 is cheaper than
>> allocating
>> 8 1-ordered pages).
>
> Its also affecting allocator speed. By having less page structures to
> manage the metadata effort is reduced. By having more objects in a page
> the fastpath of slub is more likely to be used (Visible in allocator
> benchmarks). Slub can fall back dynamically to order 0 pages if necessary.
> So it can take opportunistically take advantage of contiguous pages.

Thank you for clarification!

May be it's reasonable to fall back to order 0 pages if it's not possible
to allocate new large page without direct compaction?
I'll try to perform some tests here.

Regards,
Roman
