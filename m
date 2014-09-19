Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaISMm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:42:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43553 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISMm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:42:58 -0400
Message-ID: <541C24EC.1080200@arm.com>
Date: Fri, 19 Sep 2014 13:43:24 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "michael@amarulasolutions.com" <michael@amarulasolutions.com>,
        "fchecconi@gmail.com" <fchecconi@gmail.com>,
        "vincent@legout.info" <vincent@legout.info>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] sched/deadline: clear dl_entity params when setscheduling
 to different class
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-2-git-send-email-juri.lelli@arm.com> <541C171E.6080900@bmw-carit.de>
In-Reply-To: <541C171E.6080900@bmw-carit.de>
X-OriginalArrivalTime: 19 Sep 2014 12:42:54.0367 (UTC) FILETIME=[3B699AF0:01CFD407]
X-MC-Unique: 114091913425501401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 19/09/14 12:44, Daniel Wagner wrote:
> Hi,
> 
> On 09/19/2014 11:22 AM, Juri Lelli wrote:
>> When a task is using SCHED_DEADLINE and the user setschedules it to a different
>> class its sched_dl_entity static parameters are not cleaned up. This causes a
>> bug if the user sets it back to SCHED_DEADLINE with the same parameters again.
>> The problem resides in the check we perform at the very beginning of
>> dl_overflow():
>>
>> 	if (new_bw == p->dl.dl_bw)
>> 		return 0;
>>
>> This condition is met in the case depicted above, so the function returns and
>> dl_b->total_bw is not updated (the p->dl.dl_bw is not added to it). After this,
>> admission control is broken.
>>
>> This patch fixes the thing, properly clearing static parameters for a task
>> that ceases to use SCHED_DEADLINE.
>>
>> Reported-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
>> Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 
> Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> 
> Fixes my problem.
> 

Great! Thanks for testing it.

Best,

- Juri

