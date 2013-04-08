Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935677Ab3DHTNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:13:42 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:50458 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935227Ab3DHTNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:13:40 -0400
Message-ID: <5163159A.20800@gmail.com>
Date: Mon, 08 Apr 2013 15:08:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: fixup changers of per cpu pageset's ->high and
 ->batch
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <51618F5A.3060005@gmail.com> <5162FB82.5020607@linux.vnet.ibm.com>
In-Reply-To: <5162FB82.5020607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/8/13 1:16 PM), Cody P Schafer wrote:
> On 04/07/2013 08:23 AM, KOSAKI Motohiro wrote:
>> (4/5/13 4:33 PM), Cody P Schafer wrote:
>>> In one case while modifying the ->high and ->batch fields of per cpu pagesets
>>> we're unneededly using stop_machine() (patches 1 & 2), and in another we don't have any
>>> syncronization at all (patch 3).
>>>
>>> This patchset fixes both of them.
>>>
>>> Note that it results in a change to the behavior of zone_pcp_update(), which is
>>> used by memory_hotplug. I _think_ that I've diserned (and preserved) the
>>> essential behavior (changing ->high and ->batch), and only eliminated unneeded
>>> actions (draining the per cpu pages), but this may not be the case.
>>
>> at least, memory hotplug need to drain.
> 
> Could you explain why the drain is required here? From what I can tell,
> after the stop_machine() completes, the per cpu page sets could be
> repopulated at any point, making the combination of draining and
> modifying ->batch & ->high uneeded.

Then, memory hotplug again and again try to drain. Moreover hotplug prevent repopulation
by using MIGRATE_ISOLATE.
pcp never be page count == 0 and it prevent memory hot remove.

