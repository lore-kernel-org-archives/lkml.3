Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3KFQfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:35:19 -0500
Received: from www.sr71.net ([198.145.64.142]:58990 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3KFQfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:35:17 -0500
Message-ID: <527A6F93.8070606@sr71.net>
Date: Wed, 06 Nov 2013 08:34:27 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        dave.jiang@intel.com, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mm: thp: give transparent hugepage code a separate
 copy_page
References: <20131028221618.4078637F@viggo.jf.intel.com>	<20131028221620.042323B3@viggo.jf.intel.com> <CAJd=RBAFgn=3GvEEdHDARpw_h+6SbYE_35D5QJX7C60cVd4tmA@mail.gmail.com>
In-Reply-To: <CAJd=RBAFgn=3GvEEdHDARpw_h+6SbYE_35D5QJX7C60cVd4tmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 05:46 AM, Hillf Danton wrote:
> On Tue, Oct 29, 2013 at 6:16 AM, Dave Hansen <dave@sr71.net> wrote:
>> +
>> +void copy_high_order_page(struct page *newpage,
>> +                         struct page *oldpage,
>> +                         int order)
>> +{
>> +       int i;
>> +
>> +       might_sleep();
>> +       for (i = 0; i < (1<<order); i++) {
>> +               cond_resched();
>> +               copy_highpage(newpage + i, oldpage + i);
>> +       }
>> +}
> 
> Can we make no  use of might_sleep here with cond_resched in loop?

I'm not sure what you're saying.

Are you pointing out that cond_resched() actually calls might_sleep() so
the might_sleep() is redundant?

