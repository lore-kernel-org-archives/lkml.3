Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaBRL6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:58:54 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42996 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaBRL6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:58:53 -0500
Message-ID: <53034C66.90707@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 17:34:54 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, rientjes@google.com,
        Linus <torvalds@linux-foundation.org>, nacc@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 ] mm readahead: Fix readahead fail for memoryless cpu
 and limit readahead pages
References: <1392708338-19685-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140218094920.GB29660@quack.suse.cz>
In-Reply-To: <20140218094920.GB29660@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021811-1618-0000-0000-00000579093B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 03:19 PM, Jan Kara wrote:
> On Tue 18-02-14 12:55:38, Raghavendra K T wrote:
>> Currently max_sane_readahead() returns zero on the cpu having no local memory node
>> which leads to readahead failure. Fix the readahead failure by returning
>> minimum of (requested pages, 512). Users running application on a memory-less cpu
>> which needs readahead such as streaming application see considerable boost in the
>> performance.
>>
>> Result:
>> fadvise experiment with FADV_WILLNEED on a PPC machine having memoryless CPU
>> with 1GB testfile ( 12 iterations) yielded around 46.66% improvement.
>>
>> fadvise experiment with FADV_WILLNEED on a x240 machine with 1GB testfile
>> 32GB* 4G RAM  numa machine ( 12 iterations) showed no impact on the normal
>> NUMA cases w/ patch.
>    Can you try one more thing please? Compare startup time of some big
> executable (Firefox or LibreOffice come to my mind) for the patched and
> normal kernel on a machine which wasn't hit by this NUMA issue. And don't
> forget to do "echo 3 >/proc/sys/vm/drop_caches" before each test to flush
> the caches. If this doesn't show significant differences, I'm OK with the
> patch.
>

Thanks Honza, I checked with firefox (starting to particular point)..
I do not see any difference. Both the case took around 14sec.

  ( some time it is even faster.. may be because we do not do free page 
calculation?. )

