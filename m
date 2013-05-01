Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab3EAWg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:36:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35733 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677Ab3EAWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:36:54 -0400
Message-ID: <51819900.1010301@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 15:36:48 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mmzone: note that node_size_lock should be manipulated
 via pgdat_resize_lock()
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-4-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011528550.8804@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305011528550.8804@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-5406-0000-0000-0000081E7032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 03:29 PM, David Rientjes wrote:
> On Wed, 1 May 2013, Cody P Schafer wrote:
>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>
> Nack, pgdat_resize_unlock() is unnecessary if irqs are known to be
> disabled.
>

All this patch does is is indicate that rather than using node_size_lock 
directly (as it won't be around without CONFIG_MEMORY_HOTPLUG), one 
should use the pgdat_resize_[un]lock() helper macros.

And yes, _strictly_ speaking, one could want to avoid the 
spin_lock_irqsave/restore that pgdat_resize_*lock() does.

Right now we don't provide helpers that do that. Do you see a need for them?

