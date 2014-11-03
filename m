Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaKCJU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:20:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42480 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbaKCJUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:20:24 -0500
X-Sasl-enc: zrcSKfJRbE+bCcBhwIFcLIvvJFYeAlboK4O/xH7gidG8 1415006422
Message-ID: <1415006418.6573.6.camel@perseus.themaw.net>
Subject: Re: [PATCH 04/13] autofs4 - change printks AUTOFS defined prints
From: Ian Kent <raven@themaw.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 17:20:18 +0800
In-Reply-To: <1415003136.17743.9.camel@perches.com>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
	 <20141103081234.6215.82821.stgit@perseus.themaw.net>
	 <1415003136.17743.9.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 00:25 -0800, Joe Perches wrote:
> On Mon, 2014-11-03 at 16:12 +0800, Ian Kent wrote:
> > Use the AUTOFS_*() print defines instead of raw printks.
> 
> Please check the output of these conversions.
> 
> For instance:
> 
> > diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> []
> > @@ -162,7 +162,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
> >  		break;
> >  	}
> >  	default:
> > -		printk("autofs4_notify_daemon: bad type %d!\n", type);
> > +		AUTOFS_WARN("autofs4_notify_daemon: bad type %d!", type);
> >  		mutex_unlock(&sbi->wq_mutex);
> >  		return;
> >  	}
> 
> The current #define is:
> 
> #define AUTOFS_WARN(fmt, ...)                          \
> 	pr_warn("pid %d: %s: " fmt "\n",        \
> 		current->pid, __func__, ##__VA_ARGS__)
>  
> So this duplicates the function name in the output.

Ahh, yes, I'll fix that.

> 
> It's probably better to simply use
> 	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> or
> 	#define pr_fmt(fmt) KBUILD_MODNAME ":%d:%s" fmt, current->pid, __func__
> if you _really_ want pid/func in the output

I do, yes.

> 
> and just use pr_<level> instead of AUTOFS_<LEVEL> macros.
> 
> And it's better to use a consistent style for
> these logging functions ideally with terminating
> newlines so there isn't a mix of code with
> and without those newlines.  That inconsistency
> leads to unintended defects.

The idea here was to make the logging consistent throughout.

I have become used of not using the new-line terminator in logging over
the years and tend to favour that myself. You recommend not doing that
probably from a kernel wide consistency perspective? Maybe that is
better ...

Ian

