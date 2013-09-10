Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3IJDxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:53:51 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57341 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3IJDxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:53:49 -0400
Message-ID: <522E9793.7060003@linux.vnet.ibm.com>
Date: Tue, 10 Sep 2013 09:22:51 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, eranian@google.com,
        acme@redhat.com, Michael Neuling <michael.neuling@au1.ibm.com>,
        svaidy@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com> <1378778772.25578.1.camel@concordia>
In-Reply-To: <1378778772.25578.1.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091003-9264-0000-0000-0000047F3990
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 07:36 AM, Michael Ellerman wrote:
> On Fri, 2013-08-30 at 09:54 +0530, Anshuman Khandual wrote:
>> 	This patchset is the re-spin of the original branch stack sampling
>> patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
>> also enables SW based branch filtering support for PPC64 platforms which have
>> branch stack sampling support. With this new enablement, the branch filter support
>> for PPC64 platforms have been extended to include all these combinations discussed
>> below with a sample test application program.
> 
> ...
> 
>> Mixed filters
>> -------------
>> (6) perf record -e branch-misses:u -j any_call,any_ret ./cprog
>> Error:
>> The perf.data file has no samples!
>>
>> NOTE: As expected. The HW filters all the branches which are calls and SW tries to find return
>> branches in that given set. Both the filters are mutually exclussive, so obviously no samples
>> found in the end profile.
> 
> The semantics of multiple filters is not clear to me. It could be an OR,
> or an AND. You have implemented AND, does that match existing behaviour
> on x86 for example?

I believe it does match. X86 code drops the branch records (originally captured
in the LBR) while applying the SW filters.

Regards
Anshuman

