Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab3IDUKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:10:55 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24575 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3IDUKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:10:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,1023,1367971200"; 
   d="scan'208";a="50554118"
Message-ID: <522793CA.3060002@citrix.com>
Date: Wed, 4 Sep 2013 21:10:50 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] tracing/events: Add bounce tracing to swiotbl-xen
References: <1377208048-8963-1-git-send-email-zoltan.kiss@citrix.com> <20130823125533.GC14306@konrad-lan.dumpdata.com> <5224D0D6.40908@citrix.com> <20130903124237.GB9870@konrad-lan.dumpdata.com>
In-Reply-To: <20130903124237.GB9870@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/13 13:42, Konrad Rzeszutek Wilk wrote:
> Correct. The double buffering code is being run in lib/swiotlb.c not the
> xen-swiotlb.c. Hence the question of why not move the tracing in there.
I've put the trace to both locations before swiotlb_tbl_map_single is 
called, so the same tracer will be hit both with classic and Xen 
SWIOTLB. I used 2 different place instead of calling from 
swiotlb_tbl_map_single because I want to print out dev_addr, and it's 
calculated differently.

> Yes. And please (if it adds a benefit) also for unmap/sync which can trigger
> the bounce buffer.
>
> Or if it makes sense just for the bounce buffer copying - then just
> leave it at that. Thanks.
For me the relevant event was to see when we start to do bounce 
buffering. When does it end, or when syncing happens is a different 
thing. If someone is interested, they can easily extend this patch with 
that.

However one question bothers me: why ftrace doesn't trace these 
functions? They are not inlined, static, or marked as notrace.

Regards,

Zoli
