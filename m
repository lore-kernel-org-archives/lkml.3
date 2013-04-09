Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936746Ab3DIBxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 21:53:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33505 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3DIBxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 21:53:03 -0400
Message-ID: <51637470.5030906@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 18:52:48 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm/page_alloc: convert zone_pcp_update() to use on_each_cpu()
 instead of stop_machine()
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-3-git-send-email-cody@linux.vnet.ibm.com> <5161931A.8060501@gmail.com> <5162FF18.8010802@linux.vnet.ibm.com> <516319FF.6030104@gmail.com> <51631F4D.7050504@linux.vnet.ibm.com> <5163424A.4000106@gmail.com>
In-Reply-To: <5163424A.4000106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040901-7182-0000-0000-00000625C508
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 03:18 PM, KOSAKI Motohiro wrote:
> (4/8/13 3:49 PM), Cody P Schafer wrote:>
>> If this turns out to be an issue, schedule_on_each_cpu() could be an
>> alternative.
>
> no way. schedule_on_each_cpu() is more problematic and it should be removed
> in the future.
> schedule_on_each_cpu() can only be used when caller task don't have any lock.
> otherwise it may make deadlock.

I wasn't aware of that. Just to be clear, the deadlock you're referring 
to isn't the same one refered to in

commit b71ab8c2025caef8db719aa41af0ed735dc543cd
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Jun 29 10:07:14 2010 +0200
workqueue: increase max_active of keventd and kill current_is_keventd()

and

commit 65a64464349883891e21e74af16c05d6e1eeb4e9
Author: Andi Kleen <ak@linux.intel.com>
Date:   Wed Oct 14 06:22:47 2009 +0200
HWPOISON: Allow schedule_on_each_cpu() from keventd

If you're referencing some other deadlock, could you please provide a 
link to the relevant discussion? (I'd really like to add a note to 
schedule_on_each_cpu()'s doc comment about it so others can avoid that 
pitfall).

