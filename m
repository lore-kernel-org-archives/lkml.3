Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab3C0MDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:03:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40564
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab3C0MDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:03:20 -0400
Message-ID: <1364385776.5053.64.camel@laptop>
Subject: Re: [PATCH -mm -next] ipc,sem: fix lockdep false positive
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@surriel.com>, Sasha Levin <sasha.levin@oracle.com>,
        torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, lwoodman@redhat.com,
        chegu_vinod@hp.com, Dave Jones <davej@redhat.com>, benisty.e@gmail.com,
        Ingo Molnar <mingo@redhat.com>
Date: Wed, 27 Mar 2013 13:02:56 +0100
In-Reply-To: <CANN689G9Xt6Hmpg70x3LMy-KtccD5EvdjOW4SF+d6PsJCwK0tg@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <5150B1C2.8090607@oracle.com>
	 <20130325163844.042a45ba@annuminas.surriel.com>
	 <CANN689FdtXs0-VKxwWHQKgnnSvcvu5hHDMmGOe0H+bdHA4BhXg@mail.gmail.com>
	 <1364303965.5053.29.camel@laptop>
	 <CANN689HCbuVOc73BpVubYy2AjA2mcz_iyTg6Fo2Zz-NGnQ93TA@mail.gmail.com>
	 <1364308023.5053.40.camel@laptop> <5151BC78.3030306@surriel.com>
	 <1364373750.5053.54.camel@laptop>
	 <CANN689G9Xt6Hmpg70x3LMy-KtccD5EvdjOW4SF+d6PsJCwK0tg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 04:22 -0700, Michel Lespinasse wrote:
> >> Not without breaking your scheme above :)
> >
> > How would making sma->global_lock a mutex wreck anything?
> 
> I don't remember the details (rik probably will), but rcu is also
> already involved, so there is a non trivial chance that it would...

Ah, that might be true, the callsite might not be able to deal with it,
but the proposed global/local lock thing doesn't care -- which is how I
read Rik's comment above.

