Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934901Ab3DHRRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:17:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45612 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762680Ab3DHRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:17:04 -0400
Message-ID: <5162FB82.5020607@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 10:16:50 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: fixup changers of per cpu pageset's ->high and
 ->batch
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <51618F5A.3060005@gmail.com>
In-Reply-To: <51618F5A.3060005@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040817-7182-0000-0000-00000623E9F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 08:23 AM, KOSAKI Motohiro wrote:
> (4/5/13 4:33 PM), Cody P Schafer wrote:
>> In one case while modifying the ->high and ->batch fields of per cpu pagesets
>> we're unneededly using stop_machine() (patches 1 & 2), and in another we don't have any
>> syncronization at all (patch 3).
>>
>> This patchset fixes both of them.
>>
>> Note that it results in a change to the behavior of zone_pcp_update(), which is
>> used by memory_hotplug. I _think_ that I've diserned (and preserved) the
>> essential behavior (changing ->high and ->batch), and only eliminated unneeded
>> actions (draining the per cpu pages), but this may not be the case.
> 
> at least, memory hotplug need to drain.

Could you explain why the drain is required here? From what I can tell,
after the stop_machine() completes, the per cpu page sets could be
repopulated at any point, making the combination of draining and
modifying ->batch & ->high uneeded.

