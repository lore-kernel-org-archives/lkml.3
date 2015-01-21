Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbbAUQgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:36:15 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:46239 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbAUQgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:36:03 -0500
Date: Wed, 21 Jan 2015 19:35:59 +0300
From: Sergey Dyasly <dserrg@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: add check for the buggy while_each_thread()
Message-Id: <20150121193559.a45b6555b21bee3f627930f8@gmail.com>
In-Reply-To: <1421630853.29879.10.camel@perches.com>
References: <1421591040-4892-1-git-send-email-dserrg@gmail.com>
	<1421630853.29879.10.camel@perches.com>
X-Mailer: Sylpheed 3.4.2 (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2015 17:27:33 -0800
Joe Perches <joe@perches.com> wrote:

> On Sun, 2015-01-18 at 17:24 +0300, Sergey Dyasly wrote:
> > Now it's preferable to use for_each_thread() instead of while_each_thread().
> > Add a check to checkpatch.pl in order to prevent any new usages of the buggy
> > while_each_thread() when possible.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -3255,6 +3255,12 @@ sub process {
> >  			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
> >  		}
> >  
> > +# Check for the buggy while_each_thread()
> > +		if ($line =~ /\bwhile_each_thread\(/) {
> 
> 	\bwhile_each_thread\s*\(
> or maybe
> 	\bwhile_each_thread\b
> 
> > +			WARN("WHILE_EACH_THREAD",
> > +			     "Prefer to use for_each_thread() instead of the buggy while_each_thread(). See commit 0c740d0afc3bff0a097ad03a1c8df92757516f5c for details.\n" . $herecurr);
> 
> Pretty long commit id, 12 is probably enough.

"\bwhile_each_thread\s*\(" and 12-digit commit id sound reasonable, thanks.
I'll update the patch.

-- 
Sergey Dyasly <dserrg@gmail.com>
