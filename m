Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3LDJAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:00:21 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50524 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3LDJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:00:19 -0500
Message-ID: <529EF0FB.2050808@linux.vnet.ibm.com>
Date: Wed, 04 Dec 2013 14:38:11 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mm readahead: Fix the readahead fail in case of empty
 numa node
References: <1386066977-17368-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20131203143841.11b71e387dc1db3a8ab0974c@linux-foundation.org> <529EE811.5050306@linux.vnet.ibm.com> <20131204004125.a06f7dfc.akpm@linux-foundation.org>
In-Reply-To: <20131204004125.a06f7dfc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120409-2674-0000-0000-00000BC170D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 02:11 PM, Andrew Morton wrote:
> On Wed, 04 Dec 2013 14:00:09 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>
>> Unfaortunately, from my search, I saw that the code belonged to pre git
>> time, so could not get much information on that.
>
> Here: https://lkml.org/lkml/2004/8/20/242
>
> It seems it was done as a rather thoughtless performance optimisation.
> I'd say it's time to reimplement max_sane_readahead() from scratch.
>

Ok. Thanks for the link. I think after that,
Here it was changed to pernode:
https://lkml.org/lkml/2004/8/21/9 to avoid iteration all over.

do you think above patch (+comments) with some sanitized nr (thus
avoiding iteration over nodes in remote numa readahead case) does look
better?
or should we iterate all memory.




