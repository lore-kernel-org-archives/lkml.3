Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162757Ab3DEUl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:41:56 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55762 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162696Ab3DEUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:41:51 -0400
Message-ID: <515F370C.1030500@gmail.com>
Date: Fri, 05 Apr 2013 16:41:48 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH 02/10] migrate: make core migration code aware of hugepage
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20130325105701.GS2154@dhcp22.suse.cz> <1364272415-zvaphow7-mutt-n-horiguchi@ah.jp.nec.com> <20130326084952.GK2295@dhcp22.suse.cz>
In-Reply-To: <20130326084952.GK2295@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> There doesn't seem to be any caller for this function. Please move it to
>>> the patch which uses it.
>>
>> I would do like that if there's only one user of this function, but I thought
>> that it's better to separate this part as changes of common code
>> because this function is commonly used by multiple users which are added by
>> multiple patches later in this series.
> 
> Sure there is no hard rule for this. I just find it much easier to
> review if there is a caller of introduced functionality. In this
> particular case I found out only later that many migrate_pages callers
> were changed to use mograte_movable_pages and made the
> putback_movable_pages cleanup inconsistent between the two.
> 
> It would help to mention what is the planned future usage of the
> introduced function if you prefer to introduce it without users.

I strong agree with Michal.

