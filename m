Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaJVX0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:26:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaJVX0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:26:38 -0400
Date: Wed, 22 Oct 2014 16:26:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
Message-Id: <20141022162638.875681da6bbb9e027d2d3bee@linux-foundation.org>
In-Reply-To: <20141021202137.GA20114@www.outflux.net>
References: <20141021202137.GA20114@www.outflux.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 13:21:37 -0700 Kees Cook <keescook@chromium.org> wrote:

> From: Paul Wise <pabs3@bonedaddy.net>
> 
> This partially mitigates a common strategy used by attackers for hiding
> the full contents of strings in procfs from naive sysadmins who use cat,
> more or sysctl to inspect the contents of strings in procfs.
> 
> ...
>
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1739,7 +1739,7 @@ static int _proc_do_string(char *data, int maxlen, int write,
>  		while ((p - buffer) < *lenp && len < maxlen - 1) {
>  			if (get_user(c, p++))
>  				return -EFAULT;
> -			if (c == 0 || c == '\n')
> +			if (c == 0 || c == '\n' || c == '\r')
>  				break;
>  			data[len++] = c;
>  		}

There are no valid uses of \r in a procfs write?
