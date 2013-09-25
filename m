Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3IYR6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:58:35 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59889 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3IYR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:58:31 -0400
Date: Wed, 25 Sep 2013 10:58:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chen Gang <gang.chen@asianux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, mempolicy: make mpol_to_str robust and always
 succeed
In-Reply-To: <20130925032530.GA4771@redhat.com>
Message-ID: <alpine.DEB.2.02.1309251057080.17676@chino.kir.corp.google.com>
References: <5215639D.1080202@asianux.com> <5227CF48.5080700@asianux.com> <alpine.DEB.2.02.1309241957280.26415@chino.kir.corp.google.com> <20130925031127.GA4210@redhat.com> <alpine.DEB.2.02.1309242012070.27940@chino.kir.corp.google.com>
 <20130925032530.GA4771@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Dave Jones wrote:

>  > 	/* fall through */
>  > 
>  > for all of them would be pretty annoying.
>  
> agreed, but with that example, it seems pretty obvious (to me at least)
> that the lack of break's is intentional.  Where it gets trickier to
> make quick judgment calls is cases like the one I mentioned above,
> where there are only a few cases, and there's real code involved in
> some but not all cases.
> 

I fully agree and have code in the oom killer that has the "fall through" 
comment if there's code in between the case statements, but I think things 
like

	case MPOL_BIND:
	case MPOL_INTERLEAVE:
		...

is quite easy to read.  I don't feel strongly at all, though, so I'll just 
leave it to Andrew's preference.
