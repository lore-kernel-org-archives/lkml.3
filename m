Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3HPOPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:15:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26232 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3HPOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:15:02 -0400
Message-ID: <520E33D1.4040005@oracle.com>
Date: Fri, 16 Aug 2013 08:14:41 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>, akpm@linux-foundation.org
CC: aarcange@redhat.com, hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com,
        minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fix aio performance regression for database caused
 by THP
References: <1376590389.24607.33.camel@concerto> <20130816090425.GA2162@shutemov.name>
In-Reply-To: <20130816090425.GA2162@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 03:04 AM, Kirill A. Shutemov wrote:
> On Thu, Aug 15, 2013 at 12:13:09PM -0600, Khalid Aziz wrote:
>>
>> -	if (likely(page != page_head && get_page_unless_zero(page_head))) {
>> +	/*
>> +	 * If this is a hugetlbfs page, it can not be split under
>> +	 * us. Simply increment refcount for head page
>> +	 */
>> +	if (PageHuge(page)) {
>> +		page_head = compound_head(page);
>> +		atomic_inc(&page_head->_count);
>> +		got = true;
>
> Why not just return here and don't increase indentantion level for rest of
> the function?
>

Good point.

Andrew, I can rework the patch if you would like.

Thanks,
Khalid
