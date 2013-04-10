Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936964Ab3DJJaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:30:46 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:33996 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936947Ab3DJJao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:30:44 -0400
Date: Wed, 10 Apr 2013 11:30:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrei Epure <epure.andrei@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] include:linux: task_struct personality comment
Message-ID: <20130410093039.GA24443@gmail.com>
References: <1365512532-18730-1-git-send-email-epure.andrei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365512532-18730-1-git-send-email-epure.andrei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrei Epure <epure.andrei@gmail.com> wrote:

> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>  include/linux/sched.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6..8621bb0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1274,8 +1274,10 @@ struct task_struct {
>  	int exit_code, exit_signal;
>  	int pdeath_signal;  /*  The signal sent when the parent dies  */
>  	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
> -	/* ??? */
> +
> +	/* used with exec_domain for compatibility with other UNIX-like OSs */
>  	unsigned int personality;

I don't mind documenting the p->personality flag, but in practice it's not used 
for emulation of other OSs really, but for emulating ABI behavior with previous 
_Linux_ versions, see include/uapi/linux/personality.h:

 * Flags for bug emulation.
 *
 * These occupy the top three bytes.
 */
enum {
        UNAME26 =               0x0020000,
        ADDR_NO_RANDOMIZE =     0x0040000,      /* disable randomization of VA space */
        FDPIC_FUNCPTRS =        0x0080000,      /* userspace function ptrs point to descriptors
                                                 * (signal handling)
                                                 */
        MMAP_PAGE_ZERO =        0x0100000,
        ADDR_COMPAT_LAYOUT =    0x0200000,
        READ_IMPLIES_EXEC =     0x0400000,
        ADDR_LIMIT_32BIT =      0x0800000,
        SHORT_INODE =           0x1000000,
        WHOLE_SECONDS =         0x2000000,
        STICKY_TIMEOUTS =       0x4000000,
        ADDR_LIMIT_3GB =        0x8000000,

So the updated comment should say that.

Thanks,

	Ingo
