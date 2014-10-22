Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaJVNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:39:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44057 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaJVNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:39:26 -0400
Date: Wed, 22 Oct 2014 06:39:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
Message-ID: <20141022133919.GS4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141021202137.GA20114@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021202137.GA20114@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102213-0021-0000-0000-00000593E96D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 01:21:37PM -0700, Kees Cook wrote:
> From: Paul Wise <pabs3@bonedaddy.net>
> 
> This partially mitigates a common strategy used by attackers for hiding
> the full contents of strings in procfs from naive sysadmins who use cat,
> more or sysctl to inspect the contents of strings in procfs.
> 
> References: http://www.jakoblell.com/blog/2014/05/07/hacking-contest-hiding-stuff-from-the-terminal/
> Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/sysctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4aada6d9fe74..c34c9414caac 100644
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
> -- 
> 1.9.1
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> 

