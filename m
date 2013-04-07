Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966Ab3DGPjD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:39:03 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:35759 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945Ab3DGPjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:39:01 -0400
Message-ID: <5161931A.8060501@gmail.com>
Date: Sun, 07 Apr 2013 11:39:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 2/3] mm/page_alloc: convert zone_pcp_update() to use on_each_cpu()
 instead of stop_machine()
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-3-git-send-email-cody@linux.vnet.ibm.com>
In-Reply-To: <1365194030-28939-3-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/5/13 4:33 PM), Cody P Schafer wrote:
> No off-cpu users of the percpu pagesets exist.
> 
> zone_pcp_update()'s goal is to adjust the ->high and ->mark members of a
> percpu pageset based on a zone's ->managed_pages. We don't need to drain
> the entire percpu pageset just to modify these fields. Avoid calling
> setup_pageset() (and the draining required to call it) and instead just
> set the fields' values.
> 
> This does change the behavior of zone_pcp_update() as the percpu
> pagesets will not be drained when zone_pcp_update() is called (they will
> end up being shrunk, not completely drained, later when a 0-order page
> is freed in free_hot_cold_page()).
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>

NAK.

1) zone_pcp_update() is only used from memory hotplug and it require page drain.
2) stop_machin is used for avoiding race. just removing it is insane.


