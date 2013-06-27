Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3F0Itf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 04:49:35 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:59650 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab3F0Itd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 04:49:33 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <51CBFC95.9070002@yandex-team.ru>
Date: Thu, 27 Jun 2013 12:49:25 +0400
From: Roman Gushchin <klamm@yandex-team.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        mgorman@suse.de, glommer@parallels.com, hannes@cmpxchg.org,
        minchan@kernel.org, jiang.liu@huawei.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
References: <51BB1802.8050108@yandex-team.ru> <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com> <alpine.DEB.2.02.1306141322490.17237@chino.kir.corp.google.com> <51BF024F.2080609@yandex-team.ru> <20130617142715.GB8853@dhcp22.suse.cz> <51BF230E.8050904@yandex-team.ru> <alpine.DEB.2.02.1306171441510.20631@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1306171441510.20631@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.06.2013 01:44, David Rientjes wrote:
> On Mon, 17 Jun 2013, Roman Gushchin wrote:

> They certainly aren't enough, the kernel you're running suffers from a
> couple different memory compaction issues that were fixed in 3.7.  I
> couldn't sympathize with your situation more, I faced the same issue
> because of thp and not slub (we use slab).
>
>> I'll try to reproduce the issue on raw 3.9.
>>

I can't reproduce the issue on 3.9.
It seems that compaction fixes in 3.7 solve the problem.

>
> Thanks.  If you need to go back to 3.4, try using these, they
> significantly helped our issues:
>
> bb13ffeb9f6bfeb301443994dfbf29f91117dfb3
> 627260595ca6abcb16d68a3732bac6b547e112d6
> c89511ab2f8fe2b47585e60da8af7fd213ec877e
> 62997027ca5b3d4618198ed8b1aba40b61b1137b
> a9aacbccf3145355190d87f0df1731fb84fdd8c8

Thank you!

Regards,
Roman


