Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3IUOc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 10:32:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43292 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3IUOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 10:32:58 -0400
Date: Sat, 21 Sep 2013 15:32:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, rostedt@goodmis.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tracing: don't stuff stale pointers in filp->private_data
Message-ID: <20130921143255.GS13318@ZenIV.linux.org.uk>
References: <20130920164732.GA31520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920164732.GA31520@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 12:47:32PM -0400, Dave Jones wrote:
> Probably harmless, but still not a nice thing to do.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 368a4d5..75d3556 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1124,6 +1124,7 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>  	if (ret < 0) {
>  		trace_array_put(tr);
>  		kfree(dir);
> +		dir = NULL;
>  	}
>  
>  	filp->private_data = dir;

Er...  Why not simply return ret; instead?
