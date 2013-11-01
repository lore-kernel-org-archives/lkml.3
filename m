Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3KAMI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3KAMI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:08:26 -0400
Message-ID: <527399A0.304@redhat.com>
Date: Fri, 01 Nov 2013 08:08:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Mel Gorman <mgorman@suse.de>, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
References: <20131031163144.0fd27457@annuminas.surriel.com> <20131101110825.GX2400@suse.de> <52739244.3060209@redhat.com>
In-Reply-To: <52739244.3060209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/01/2013 07:36 AM, Rik van Riel wrote:
> On 11/01/2013 07:08 AM, Mel Gorman wrote:
>> On Thu, Oct 31, 2013 at 04:31:44PM -0400, Rik van Riel wrote:
>>> There is a race between stop_two_cpus, and the global stop_cpus.
>>>
>>
>> What was the trigger for this? I want to see what was missing from my own
>> testing. I'm going to go out on a limb and guess that CPU hotplug was also
>> running in the background to specifically stress this sort of rare condition.
>> Something like running a standard test with the monitors/watch-cpuoffline.sh
>> from mmtests running in parallel.
> 
> AFAIK the trigger was a test that continuously loads and
> unloads kernel modules, while doing other stuff.
>

With this patch in place the module load/unload test ran for ~16 hours without
failure.  Without the patch the test usually fails in 5-10 minutes.

Tested-by: Prarit Bhargava <prarit@redhat.com>

P.
