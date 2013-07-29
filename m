Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3G2TAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:00:32 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43919 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3G2TA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:00:28 -0400
Message-ID: <51F6BBEC.5070203@gmail.com>
Date: Mon, 29 Jul 2013 15:01:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [patch 4/6] x86: finish user fault error path with fatal signal
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org> <1374791138-15665-5-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1374791138-15665-5-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(7/25/13 6:25 PM), Johannes Weiner wrote:
> The x86 fault handler bails in the middle of error handling when the
> task has a fatal signal pending.  For a subsequent patch this is a
> problem in OOM situations because it relies on
> pagefault_out_of_memory() being called even when the task has been
> killed, to perform proper per-task OOM state unwinding.
> 
> Shortcutting the fault like this is a rather minor optimization that
> saves a few instructions in rare cases.  Just remove it for
> user-triggered faults.
> 
> Use the opportunity to split the fault retry handling from actual
> fault errors and add locking documentation that reads suprisingly
> similar to ARM's.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

