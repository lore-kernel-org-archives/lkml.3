Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936314Ab3DHXKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:10:22 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:65463 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3DHXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:10:20 -0400
Message-ID: <51634E58.4080104@gmail.com>
Date: Mon, 08 Apr 2013 19:10:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Matthew Wilcox <willy@linux.intel.com>, kosaki.motohiro@gmail.com
Subject: Re: [RFC PATCH 1/1] mm: Another attempt to monitor task's memory
 changes
References: <515F0484.1010703@parallels.com>
In-Reply-To: <515F0484.1010703@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This approach works on any task via it's proc, and can be used on different
> tasks in parallel.
> 
> Also, Andrew was asking for some performance numbers related to the change.
> Now I can say, that as long as soft dirty bits are not cleared, no performance
> penalty occur, since the soft dirty bit and the regular dirty bit are set at 
> the same time within the same instruction. When soft dirty is cleared via 
> clear_refs, the task in question might slow down, but it will depend on how
> actively it uses the memory.
> 
> 
> What do you think, does it make sense to develop this approach further?

When touching mmaped page, cpu turns on dirty bit but doesn't turn on soft dirty.
So, I'm not convinced how to use this flag. Please show us your userland algorithm
how to detect diff.


