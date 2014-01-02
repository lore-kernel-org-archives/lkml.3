Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaABWKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:10:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:46894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaABWKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:10:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,593,1384329600"; 
   d="scan'208";a="433191734"
Message-ID: <52C5E3C2.6020205@intel.com>
Date: Thu, 02 Jan 2014 14:10:10 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
References: <20140101002935.GA15683@localhost.localdomain> <52C5AA61.8060701@intel.com> <alpine.DEB.2.02.1401021357360.21537@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401021357360.21537@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 01:58 PM, David Rientjes wrote:
> On Thu, 2 Jan 2014, Dave Hansen wrote:
> 
>>> min_free_kbytes may be updated during thp's initialization. Sometimes,
>>> this will change the value being set by user. Showing message will
>>> clarify this confusion.
>> ...
>>> -	if (recommended_min > min_free_kbytes)
>>> +	if (recommended_min > min_free_kbytes) {
>>>  		min_free_kbytes = recommended_min;
>>> +		pr_info("min_free_kbytes is updated to %d by enabling transparent hugepage.\n",
>>> +			min_free_kbytes);
>>> +	}
>>
>> "updated" doesn't tell us much.  It's also kinda nasty that if we enable
>> then disable THP, we end up with an elevated min_free_kbytes.  Maybe we
>> should at least put something in that tells the user how to get back
>> where they were if they care:
> 
> The default value of min_free_kbytes depends on the implementation of the 
> VM regardless of any config options that you may have enabled.  We don't 
> specify what the non-thp default is in the kernel log, so why do we need 
> to specify what the thp default is?

Let's say enabling THP made my system behave badly.  How do I get it
back to the state before I enabled THP?  The user has to have gone and
recorded what their min_free_kbytes was before turning THP on in order
to get it back to where it was.  Folks also have to either plan in
advance (archiving *ALL* the sysctl settings), somehow *know* somehow
that THP can affect min_free_kbytes, or just plain be clairvoyant.

This seems like a pretty straightforward way to be transparent about
what the kernel mucked with, and exactly how it did it instead of
requiring clairvoyant sysadmins.

