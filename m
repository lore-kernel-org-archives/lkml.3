Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3E0Txs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 15:53:48 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52122 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3E0Txr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 15:53:47 -0400
Message-ID: <51A3B9C7.7040300@colorfullife.com>
Date: Mon, 27 May 2013 21:53:43 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] ipc/sem.c: Fix missing wakeups in do_smart_update_queue()
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com> <1369559335-13491-2-git-send-email-manfred@colorfullife.com> <51A39D19.4070400@redhat.com>
In-Reply-To: <51A39D19.4070400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On 05/27/2013 07:51 PM, Rik van Riel wrote:
>
> Very much not optimized, but we need to fix the regression.
>
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks for the review.

I was afraid that the differences would be noticeable but they aren't:
At least on my laptop, the differences between the patches are within 
the noise:

# ./cat /proc/stat | grep ctxt;./osim 2 2 1000000 0 0;cat /proc/stat | 
grep ctxt
runtime: stock    patch 1    patch 1-4
2,0088875    2,041084    1,997367

# ./cat /proc/stat | grep ctxt;./osim 2 20 1000000 0 0;cat /proc/stat | 
grep ctxt
4,32541    4,295956    4,277817

(assuming 2 cpus, otherwise increase "2" and "20" accordingly)

Here is the link to the tool:
http://marc.info/?l=linux-kernel&m=125038376609750

--
     Manfred

