Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaJAV0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:26:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJAV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:26:00 -0400
Date: Wed, 1 Oct 2014 14:25:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        minchan@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mm, compaction: using uninitialized_var insteads
 setting 'flags' to 0 directly.
Message-Id: <20141001142559.20b8c87f792bc046cdabd309@linux-foundation.org>
In-Reply-To: <542C6FB2.8000503@suse.cz>
References: <1411961425-8045-1-git-send-email-Li.Xiubo@freescale.com>
	<542A5B5B.7060207@suse.cz>
	<alpine.DEB.2.02.1410011314180.21593@chino.kir.corp.google.com>
	<542C6FB2.8000503@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014 23:18:42 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 10/01/2014 10:16 PM, David Rientjes wrote:
> >> On 09/29/2014 05:30 AM, Xiubo Li wrote:
> >> > Setting 'flags' to zero will be certainly a misleading way to avoid
> >> > warning of 'flags' may be used uninitialized. uninitialized_var is
> >> > a correct way because the warning is a false possitive.
> >> 
> >> Agree.
> >> 
> >> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> >> 
> >> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> >> 
> > 
> > I thought we just discussed this when 
> > mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch was 
> > merged and, although I liked it, it was stated that we shouldn't add any 
> > new users of uninitialized_var().
> 
> Yeah but that discussion wasn't unfortunately CC'd on mailing lists. And my
> interpretation of the outcome is that maybe we should try :)
> 

https://lkml.org/lkml/2012/10/27/71

I disagree, can't be bothered getting into a fight over it.  I do tend
to accidentally let new uses sneak into the tree, but this one is a bit
obvious.

