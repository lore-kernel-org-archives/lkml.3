Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaD2GA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:00:29 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:54986 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaD2GA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:00:27 -0400
Message-ID: <535F3FC4.7050906@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 11:29:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: mroos@linux.ee, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Cpufreq frequency serialization fixes
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com> <9665161.ytKRFCMQPA@vostro.rjw.lan>
In-Reply-To: <9665161.ytKRFCMQPA@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042906-3864-0000-0000-00000DED3CA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 05:17 AM, Rafael J. Wysocki wrote:
> On Tuesday, April 29, 2014 12:23:54 AM Srivatsa S. Bhat wrote:
>>
>> Hi,
>>
>> Meelis Roos reported hangs during boot in the longhaul cpufreq driver, after
>> commit 12478cf0c55 (cpufreq: Make sure frequency transitions are serialized).
>> The root-cause of this issue is the extra invocation of the
>> cpufreq_freq_transition_begin() and cpufreq_freq_transition_end() APIs in the
>> longhaul driver. I found similar issues in the powernow-k6 and powernow-k7
>> drivers as well. This patchset fixes the issue in all the 3 drivers and also
>> adds a debug infrastructure to catch such issues easily.
>>
>> Patches 1-4 fix the regression in longhaul, powernow-k6 and powernow-k7
>> drivers. (Patch 2 fixes a different bug in powernow-k6, and it is kept as a
>> separate patch instead of merging it with patch 3, because I felt that it was
>> a bit subtle and needed attention in a separate patch).
>>
>> Patch 5 adds a debug infrastructure to the cpufreq core to catch such problems
>> more easily in the future.
> 
> I've queued up patches [1-4/5] for 3.15, the last one I need to have another
> look at tomorrow.

Great! Thanks a lot!

> 
> BTW, when you fix regressions, please always add a Fixes: tag to the changelog.
>

Oh, ok, will keep that in mind from next time. Thank you!
 
Regards,
Srivatsa S. Bhat

