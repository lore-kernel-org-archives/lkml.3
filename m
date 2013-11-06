Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3KFDAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:00:43 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37405 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3KFDAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:00:42 -0500
Date: Wed, 6 Nov 2013 04:00:04 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Luigi Semenzato <semenzato@google.com>, Sameer Nanda <snanda@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>, rusty@rustcorp.com.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, oleg@redhat.com,
        dserrg@gmail.com
Subject: Re: [PATCH] mm, oom: Fix race when selecting process to kill
Message-ID: <20131106030000.GA1934@hp530>
References: <1383693987-14171-1-git-send-email-snanda@chromium.org>
 <alpine.DEB.2.02.1311051715090.29471@chino.kir.corp.google.com>
 <CAA25o9SFZW7JxDQGv+h43EMSS3xH0eXy=LoHO_Psmk_n3dxqoA@mail.gmail.com>
 <alpine.DEB.2.02.1311051727090.29471@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311051727090.29471@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Oleg and Sergey

On Tue, Nov 05, 2013 at 05:27:29PM -0800, David Rientjes wrote:
> On Tue, 5 Nov 2013, Luigi Semenzato wrote:
> 
> > It's not enough to hold a reference to the task struct, because it can
> > still be taken out of the circular list of threads.  The RCU
> > assumptions don't hold in that case.
> > 
> 
> Could you please post a proper bug report that isolates this at the cause?
>
Hi David!

I think it has already been reported[1] and actively discussed. Oleg has
confirmed that while_each_thread() is not safe under rcu_read_lock()[2].

Oleg, any news about your activity for fixing that?

[1] http://www.spinics.net/lists/linux-mm/msg54836.html
[2] http://marc.info/?l=linux-kernel&m=127688978121665
> Thanks.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
