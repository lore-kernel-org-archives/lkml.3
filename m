Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163100Ab3DFAPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 20:15:50 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:61804 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163044Ab3DFAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 20:15:49 -0400
Message-ID: <515F6934.1090508@gmail.com>
Date: Fri, 05 Apr 2013 20:15:48 -0400
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
Subject: Re: [PATCH 10/10] prepare to remove /proc/sys/vm/hugepages_treat_as_movable
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-11-git-send-email-n-horiguchi@ah.jp.nec.com> <20130325151246.GB2154@dhcp22.suse.cz>
In-Reply-To: <20130325151246.GB2154@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/25/13 11:12 AM), Michal Hocko wrote:
> On Fri 22-03-13 16:23:55, Naoya Horiguchi wrote:
> [...]
>> @@ -2086,11 +2085,7 @@ int hugetlb_treat_movable_handler(struct ctl_table *table, int write,
>>  			void __user *buffer,
>>  			size_t *length, loff_t *ppos)
>>  {
>> -	proc_dointvec(table, write, buffer, length, ppos);
>> -	if (hugepages_treat_as_movable)
>> -		htlb_alloc_mask = GFP_HIGHUSER_MOVABLE;
>> -	else
>> -		htlb_alloc_mask = GFP_HIGHUSER;
>> +	/* hugepages_treat_as_movable is obsolete and to be removed. */
> 
> WARN_ON_ONCE("This knob is obsolete and has no effect. It is scheduled for removal")

Indeed.
