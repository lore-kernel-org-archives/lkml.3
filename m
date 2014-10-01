Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaJAUQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:16:37 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33563 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaJAUQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:16:36 -0400
Date: Wed, 1 Oct 2014 13:16:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Xiubo Li <Li.Xiubo@freescale.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH] mm, compaction: using uninitialized_var insteads setting
 'flags' to 0 directly.
In-Reply-To: <542A5B5B.7060207@suse.cz>
Message-ID: <alpine.DEB.2.02.1410011314180.21593@chino.kir.corp.google.com>
References: <1411961425-8045-1-git-send-email-Li.Xiubo@freescale.com> <542A5B5B.7060207@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Vlastimil Babka wrote:

> On 09/29/2014 05:30 AM, Xiubo Li wrote:
> > Setting 'flags' to zero will be certainly a misleading way to avoid
> > warning of 'flags' may be used uninitialized. uninitialized_var is
> > a correct way because the warning is a false possitive.
> 
> Agree.
> 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> 

I thought we just discussed this when 
mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch was 
merged and, although I liked it, it was stated that we shouldn't add any 
new users of uninitialized_var().
