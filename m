Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3IBDid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 23:38:33 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58830 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab3IBDib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 23:38:31 -0400
Message-ID: <52240800.6060002@linux.vnet.ibm.com>
Date: Mon, 02 Sep 2013 09:07:36 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        michael.neuling@au1.ibm.com, ellerman@au1.ibm.com,
        svaidy@linux.vnet.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com> <CABPqkBS2AD873tHnyCHeC7uwsJdP1V6=8WGUTHG+R0z2pphHjQ@mail.gmail.com>
In-Reply-To: <CABPqkBS2AD873tHnyCHeC7uwsJdP1V6=8WGUTHG+R0z2pphHjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090203-0260-0000-0000-0000038E3CD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 05:18 PM, Stephane Eranian wrote:
> 2013/8/30 Anshuman Khandual <khandual@linux.vnet.ibm.com>
>> >
>> >         This patchset is the re-spin of the original branch stack sampling
>> > patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
>> > also enables SW based branch filtering support for PPC64 platforms which have
>> > branch stack sampling support. With this new enablement, the branch filter support
>> > for PPC64 platforms have been extended to include all these combinations discussed
>> > below with a sample test application program.
>> >
>> >
> I am trying to understand which HW has support for capturing the
> branches: PPC7 or PPC8.
> Then it seems you're saying that only PPC8 has the filtering support.
> On PPC7 you use the
> SW filter. Did I get this right?
> 
> I will look at the patch set.
> 

Hey Stephane,

POWER7 does not have BHRB support required to capture the branches. Right
now its only POWER8 (which has BHRB) can capture branches in HW. It has some
PMU level branch filters and rest we have implemented in SW. But these SW
filters cannot be applied in POWER7 as it does not support branch stack 
sampling because of lack of BHRB. I have mentioned PPC64 support in the
sense that this SW filtering code could be used in existing or future generation
powerpc processors which would have PMU support for branch stack sampling. My
apologies if the description for the patchset was ambiguous.

Regards
Anshuman

