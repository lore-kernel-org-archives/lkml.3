Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaAYIsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 03:48:06 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42012 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 03:48:04 -0500
Date: Sat, 25 Jan 2014 09:48:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mingo@redhat.com,
        oleg@redhat.com, riel@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH v5 1/2] sysctl: Make neg_one a standard constraint
Message-ID: <20140125084800.GA16070@gmail.com>
References: <1390474563-15424-1-git-send-email-atomlin@redhat.com>
 <1390474563-15424-2-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390474563-15424-2-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aaron Tomlin <atomlin@redhat.com> wrote:

> Add neg_one to the list of standard constraints.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> ---
>  kernel/sysctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 34a6047..dd531a6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -122,6 +122,7 @@ extern int blk_iopoll_enabled;
>  static int sixty = 60;
>  #endif
>  
> +static int neg_one = -1;
>  static int zero;
>  static int __maybe_unused one = 1;
>  static int __maybe_unused two = 2;

So what happens if CONFIG_DETECT_HUNG_TASK is not defined and neg_one 
is unused? The compiler generates an unused variable warning.

Thanks,

	Ingo


