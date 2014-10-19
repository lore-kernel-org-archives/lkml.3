Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaJSRTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:19:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54936 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJSRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:18:59 -0400
Date: Sun, 19 Oct 2014 13:18:55 -0400 (EDT)
Message-Id: <20141019.131855.1429160564158795766.davem@davemloft.net>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410192011410.32417@adalberg.ut.ee>
References: <20141018.142335.1935310766779155342.davem@davemloft.net>
	<alpine.LRH.2.11.1410191459210.32417@adalberg.ut.ee>
	<alpine.LRH.2.11.1410192011410.32417@adalberg.ut.ee>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 10:18:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Sun, 19 Oct 2014 20:12:43 +0300 (EEST)

>> > > I don't want to define the array size of the fpregs save area
>> > > explicitly and thereby placing an artificial limit there.
>> > 
>> > Nevermind, it seems we have a hard limit of 7 FPU save areas anyways.
>> > 
>> > Meelis, please try this patch:
>> 
>> Works fine with 3.17.0-09670-g0429fbc + fault patch.
>> 
>> Will try current git next to find any new problems :)
> 
> Works on all 3 machines, with latest git (only had to apply the no-ipv6 
> patch on one of them). Thank you for the good work!

Thanks for testing.

Hopefully we can kill the gcc-4.9 bug next, and then see if that
exit_mmap() crash is still happening.
