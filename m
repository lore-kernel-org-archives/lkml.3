Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3IYDSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:18:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33954 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3IYDST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:18:19 -0400
Date: Tue, 24 Sep 2013 20:18:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Chen Gang <gang.chen@asianux.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, mempolicy: make mpol_to_str robust and always
 succeed
In-Reply-To: <20130925031127.GA4210@redhat.com>
Message-ID: <alpine.DEB.2.02.1309242012070.27940@chino.kir.corp.google.com>
References: <5215639D.1080202@asianux.com> <5227CF48.5080700@asianux.com> <alpine.DEB.2.02.1309241957280.26415@chino.kir.corp.google.com> <20130925031127.GA4210@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013, Dave Jones wrote:

>  >  	case MPOL_BIND:
>  > -		/* Fall through */
>  >  	case MPOL_INTERLEAVE:
>  >  		nodes = pol->v.nodes;
>  >  		break;
> 
> Any reason not to leave this ?
> 
> "missing break" is the 2nd most common thing that coverity picks up.
> Most of them are false positives like the above, but the lack of annotations
> in our source makes it time-consuming to pick through them all to find the
> real bugs.
> 

Check out things like drivers/mfd/wm5110-tables.c that do things like

	switch (reg) {
	case ARIZONA_SOFTWARE_RESET:
	case ARIZONA_DEVICE_REVISION:
	case ARIZONA_CTRL_IF_SPI_CFG_1:
	case ARIZONA_CTRL_IF_I2C1_CFG_1:
	case ARIZONA_CTRL_IF_I2C2_CFG_1:
	case ARIZONA_CTRL_IF_I2C1_CFG_2:
	case ARIZONA_CTRL_IF_I2C2_CFG_2:
	...

and that file has over 1,000 case statements.  Having a

	/* fall through */

for all of them would be pretty annoying.

I don't remember any coding style rule about this (in fact 
Documentation/CodingStyle has examples of case statements without such a 
comment), I think it's just personal preference so I'll leave it to Andrew 
and what he prefers.

(And if he prefers the /* fall through */ then we should ask that it be 
added to checkpatch.pl since it warns about a million other things and not 
this.)
