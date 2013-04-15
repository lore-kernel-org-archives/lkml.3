Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3DOVCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:02:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3DOVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:02:31 -0400
Date: Mon, 15 Apr 2013 14:02:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH 2/2] audit: remove unnecessary #if CONFIG_AUDIT
Message-Id: <20130415140230.60917c685decaeb2b7fb0452@linux-foundation.org>
In-Reply-To: <1365759261-21927-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1365759261-21927-1-git-send-email-gaofeng@cn.fujitsu.com>
	<1365759261-21927-2-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013 17:34:21 +0800 Gao feng <gaofeng@cn.fujitsu.com> wrote:

> The files include kernel/audit.h are complied only
> when CONFIG_AUDIT is set.
> 
> Just like audit_pid,there is no need to surround
> audit_ever_enabled with CONFIG_AUDIT.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  kernel/audit.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/audit.h b/kernel/audit.h
> index d06ffc1..11468d9 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -59,9 +59,7 @@ struct audit_entry {
>  	struct audit_krule	rule;
>  };
>  
> -#ifdef CONFIG_AUDIT
>  extern int audit_ever_enabled;
> -#endif
>  
>  extern int audit_pid;

Well actually there's no need to put the ifdefs around such an extern
declaration at all.  The one small downside to omitting the ifdefs is
that a programming mistake may then be revealed at link-time instead of
at compile-time.  But we very often omit the ifdefs, because reducing visual
clutter is more important.


