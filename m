Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3DXGJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:09:46 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:43882 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3DXGJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:09:44 -0400
Date: Wed, 24 Apr 2013 01:09:14 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [HELP] Documentation on
 CPU:/sys/devices/system/cpu/cpuX/cache/indexX/shared_cpu_map
To: Ren Zhen <darwin.xupt@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <CACbbJybOB5x=FKA4GADZSPr3=Jr9KOM1aHg3eBipoXLLnJ6fEw@mail.gmail.com>
In-Reply-To: <CACbbJybOB5x=FKA4GADZSPr3=Jr9KOM1aHg3eBipoXLLnJ6fEw@mail.gmail.com>
	(from darwin.xupt@gmail.com on Tue Apr 23 08:07:44 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1366783754.18069.157@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:07:44 AM, Ren Zhen wrote:
> Hi all:
>     Can anybody help me to understand the usage of 'shared_cpu_map' in
> /sys/devices/system/cpu/cpuX/cache/indexX/.
>     when I execute the cmd--'#cat shared_cpu_map', it retures '05'.
>      And my computer use Ubuntu12.04,Intel core i3 CPU.
>      I have read one email in LKML,it says:
> 
> "The patch also adds a bunch of interfaces under
> /sys/devices/system/cpu/cpuX/cache, showing various information about  
> the
> caches.  Most useful field being shared_cpu_map, which says what  
> caches are
> shared among which logical cpus. "
> 
>      But I still cannot catch the meaning of  'which says what caches
> are shared among which logical cpus'.

Sounds like it means the L2 cache would be a communal resource shared  
between processors on die. So either processor could fault in cache  
lines into that pool of memory, evicting other cache lines as necessary  
to make space. So if only one processor was running, it could act like  
it had twice as much L2 cache because the memory it faulted in would  
(statistically speaking) stay in L2 cache longer before being evicted  
to make way for other memory accesses.

At a guess, the bits set (1<<0 and 1<<2 in this case) indicate which  
cpus access memory through the same pool of L2 cache.

Rob