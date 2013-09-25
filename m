Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3IYWGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:06:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3IYWGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:06:53 -0400
Date: Wed, 25 Sep 2013 15:06:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chen Gang <gang.chen@asianux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, mempolicy: make mpol_to_str robust and always
 succeed
In-Reply-To: <20130925143009.913fb1c042abe10d91c86c8b@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1309251505330.1835@chino.kir.corp.google.com>
References: <5215639D.1080202@asianux.com> <5227CF48.5080700@asianux.com> <alpine.DEB.2.02.1309241957280.26415@chino.kir.corp.google.com> <20130925031127.GA4210@redhat.com> <alpine.DEB.2.02.1309242012070.27940@chino.kir.corp.google.com> <20130925032530.GA4771@redhat.com>
 <alpine.DEB.2.02.1309251057080.17676@chino.kir.corp.google.com> <20130925143009.913fb1c042abe10d91c86c8b@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Andrew Morton wrote:

> > I fully agree and have code in the oom killer that has the "fall through" 
> > comment if there's code in between the case statements, but I think things 
> > like
> > 
> > 	case MPOL_BIND:
> > 	case MPOL_INTERLEAVE:
> > 		...
> > 
> > is quite easy to read.  I don't feel strongly at all, though, so I'll just 
> > leave it to Andrew's preference.
> 
> I've never even thought about it, but that won't prevent me from
> pretending otherwise!  How about:
> 
> This:
> 
> 	case WIBBLE:
> 		something();
> 		something_else();
> 	case WOBBLE:
> 
> needs a /* fall through */ comment (because it *looks* like a mistake),
> whereas
> 
> 	case WIBBLE:
> 	case WOBBLE:
> 
> does not?
> 

The switch-case examples given in Documentation/CodingStyle agree with 
that.
