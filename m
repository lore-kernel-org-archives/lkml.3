Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3AQL4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:56:43 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:50661 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3AQL4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:56:41 -0500
Date: Thu, 17 Jan 2013 11:56:37 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Richard Mortimer <richm@oldelvet.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc: kernel/sbus.c: fix memory leakage
Message-ID: <20130117115637.GB25615@gmail.com>
References: <1358199372-11976-1-git-send-email-dinggnu@gmail.com>
 <20130116211309.GA13993@merkur.ravnborg.org>
 <20130116211725.GC18593@gmail.com>
 <20130116220018.GA14063@merkur.ravnborg.org>
 <20130116220153.GD18593@gmail.com>
 <50F7D577.8010506@oldelvet.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F7D577.8010506@oldelvet.org.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:41:59AM +0000, Richard Mortimer wrote:
> 
> 
> On 16/01/2013 22:01, Cong Ding wrote:
> >the variable iommu and strbuf are not freed if it goes to error.
> >
> >Signed-off-by: Cong Ding <dinggnu@gmail.com>
> >---
> >  arch/sparc/kernel/sbus.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> >diff --git a/arch/sparc/kernel/sbus.c b/arch/sparc/kernel/sbus.c
> >index 1271b3a..78aa26b 100644
> >--- a/arch/sparc/kernel/sbus.c
> >+++ b/arch/sparc/kernel/sbus.c
> >@@ -656,6 +656,8 @@ static void __init sbus_iommu_init(struct platform_device *op)
> >  	return;
> >
> >  fatal_memory_error:
> >+	kfree(strbuf);
> 
> strbuf will be uninitialized if the iommu allocation fails. I don't
> have a particular preference for how to fix this but tend to dislike
> initial assignment with NULL because it hides other control flow
> issues.
Sorry I didn't notice strbuf will be uninitialized here. But if we don't
initially assign a NULL value to strbuf, I cannot find a way to handle it
besides the first version patch. Did you have any suggestions? For me, I like
the first version.
- cong
> 
> Regards
> 
> Richard
> 
> >+	kfree(iommu);
> >  	prom_printf("sbus_iommu_init: Fatal memory allocation error.\n");
> >  }
> >
> >
