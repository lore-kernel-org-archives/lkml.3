Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967567AbaFTSuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:50:50 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55629 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966716AbaFTSus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:50:48 -0400
Message-ID: <53A4828D.9000200@kernel.dk>
Date: Fri, 20 Jun 2014 12:50:53 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>
CC: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH block/for-linus] blkcg: fix use-after-free in __blkg_release_rcu()
 by making blkcg_gq refcnt an atomic_t
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com> <20140609174708.GA31499@redhat.com> <20140609182728.GB31499@redhat.com> <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com> <20140611163229.GA12974@redhat.com> <20140619202640.GA9814@mtj.dyndns.org> <20140619214257.GE9814@mtj.dyndns.org> <20140620143901.GC7354@redhat.com>
In-Reply-To: <20140620143901.GC7354@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 08:39 AM, Vivek Goyal wrote:
> On Thu, Jun 19, 2014 at 05:42:57PM -0400, Tejun Heo wrote:
>> Hello,
>>
>> So, this patch should do.  Joe, Vivek, can one of you guys please
>> verify that the oops goes away with this patch?
> 
> Hi Tejun,
> 
> This patch seems to fix the issue for me. Tried 10 times and no crash.
> 
> So now one need to hold queue lock for getting refernce on the group
> only if caller does not already have a reference and if group has been
> looked up from some tree/queue etc. I guess only such usage seems to
> be in blkg_create() where we take a reference on parent after looking
> it up.
> 
> This patch looks good to me.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks. Tejun, I'll queue this up for this cycle.

-- 
Jens Axboe

