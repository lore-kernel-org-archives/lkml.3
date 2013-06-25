Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3FYBAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:00:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45671 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3FYBAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:00:40 -0400
X-AuditID: 9c93016f-b7b0aae0000032af-a2-51c8ebb513e5
Message-ID: <51C8EBB5.3040000@lge.com>
Date: Tue, 25 Jun 2013 10:00:37 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf sort: Separate out memory-specific sort
 keys
References: <1364991979-3008-3-git-send-email-namhyung@kernel.org> <tip-afab87b91f3f331d55664172dad8e476e6ffca9d@git.kernel.org> <20130625003010.GU6123@two.firstfloor.org>
In-Reply-To: <20130625003010.GU6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

2013-06-25 AM 9:30, Andi Kleen wrote:
> On Fri, May 31, 2013 at 04:20:20AM -0700, tip-bot for Namhyung Kim wrote:
>> perf sort: Separate out memory-specific sort keys
>>
>> Since they're used only for perf mem, separate out them to a different
>> dimension so that normal user cannot access them by any chance.
>>
>> For global/local weights, I'm not entirely sure to place them into the
>> memory dimension.  But it's the only user at this time.
>
> So I was finally able to test with this patch, but
> I found it completely breaks TSX weight abort profiling.
>
> It uses weight (global/local), but it's not
> running in memory mode.
>
> I'll send a patch to move weight back into
> the common keys.

I'm not sure it should move to the common keys as normal perf session 
won't have those.  I guess you need to set up a couple of TSX-specific 
sort keys like perf mem, if so what about moving the two weights to your 
table?

Thanks,
Namhyung
