Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab3DGPXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:23:04 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61847 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933888Ab3DGPXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:23:02 -0400
Message-ID: <51618F5A.3060005@gmail.com>
Date: Sun, 07 Apr 2013 11:23:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 0/3] mm: fixup changers of per cpu pageset's ->high and
 ->batch
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/5/13 4:33 PM), Cody P Schafer wrote:
> In one case while modifying the ->high and ->batch fields of per cpu pagesets
> we're unneededly using stop_machine() (patches 1 & 2), and in another we don't have any
> syncronization at all (patch 3).
> 
> This patchset fixes both of them.
> 
> Note that it results in a change to the behavior of zone_pcp_update(), which is
> used by memory_hotplug. I _think_ that I've diserned (and preserved) the
> essential behavior (changing ->high and ->batch), and only eliminated unneeded
> actions (draining the per cpu pages), but this may not be the case.

at least, memory hotplug need to drain.


