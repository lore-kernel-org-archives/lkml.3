Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3FQB4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 21:56:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab3FQBz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 21:55:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,877,1363104000"; 
   d="scan'208";a="7570620"
Message-ID: <51BE6BFC.3030009@cn.fujitsu.com>
Date: Mon, 17 Jun 2013 09:53:00 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Add unlikely for current_order test
References: <51BC4A83.50302@gmail.com> <alpine.DEB.2.02.1306161103020.22688@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1306161103020.22688@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/17 09:53:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/17 09:53:58,
	Serialize complete at 2013/06/17 09:53:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 06/17/2013 02:04 AM, David Rientjes wrote:
> On Sat, 15 Jun 2013, Zhang Yanfei wrote:
> 
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>
>> Since we have an unlikely for the "current_order >= pageblock_order / 2"
>> test above, adding an unlikely for this "current_order >= pageblock_order"
>> test seems more appropriate.
>>
> 
> I don't understand the justification at all, current_order being unlikely 
> greater than or equal to pageblock_order / 2 doesn't imply at all that 
> it's unlikely that current_order is greater than or equal to 
> pageblock_order.
> 

hmmm... I am confused. Since current_order is >= pageblock_order / 2 is unlikely,
why current_order is >= pageblock_order isn't unlikely. Or there are other
tips?

Actually, I am also a little confused about why current_order should be
unlikely greater than or equal to pageblock_order / 2. When borrowing pages
with other migrate_type, we always search from MAX_ORDER-1, which is greater
or equal to pageblock_order.

-- 
Thanks.
Zhang Yanfei
