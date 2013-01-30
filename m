Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3A3Ky7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:54:59 -0500
Received: from multi.imgtec.com ([194.200.65.239]:39836 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3A3Ky4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:54:56 -0500
Message-ID: <5108FBFD.8080705@imgtec.com>
Date: Wed, 30 Jan 2013 10:54:53 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Robert Richter <rric@kernel.org>,
        <oprofile-list@lists.sf.net>
Subject: Re: [PATCH v3 40/71] ARC: OProfile support
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com> <1359025589-22277-25-git-send-email-vgupta@synopsys.com> <5108016B.5050303@imgtec.com> <5108BEF5.6030500@synopsys.com>
In-Reply-To: <5108BEF5.6030500@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_30_10_54_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/13 06:34, Vineet Gupta wrote:
> On Tuesday 29 January 2013 10:35 PM, James Hogan wrote:
>> Hi Vineet,
>>
>> You don't appear to define CONFIG_HW_PERF_EVENTS, so
>> include/linux/oprofile.h will presumably define oprofile_perf_init as
>> just a pr_info(...); return -ENODEV;
>>
>> Similarly drivers/oprofile/oprofile_perf.o doesn't seem to be being built.
>>
>> I'm probably missing something somewhere?
> 
> Not much :-)
> 
> oprofile_arch_init() failure causes oprofile to fall back to timer based PC only
> sampling - for coarse grained profiling. I'll soon be starting on integratign the
> hardware counter support to both oprofile/perf.

Okay cool. It's just slightly misleading for anybody copying the code
that it calls oprofile_perf_init which is known never to do anything
:-). Maybe it's worth adding a comment in there to clarify. If it's only
temporary I'm fine with it.

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

