Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbaFYNq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:46:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbaFYNqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:46:24 -0400
Date: Wed, 25 Jun 2014 15:43:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v8 4/9] sched: move no_new_privs into new atomic flags
Message-ID: <20140625134354.GA7892@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403642893-23107-5-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Kees Cook wrote:
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1307,8 +1307,7 @@ struct task_struct {
>  				 * execve */
>  	unsigned in_iowait:1;
>
> -	/* task may not gain privileges */
> -	unsigned no_new_privs:1;
> +	unsigned long atomic_flags; /* Flags needing atomic access. */
>
>  	/* Revert to default priority/policy when forking */
>  	unsigned sched_reset_on_fork:1;

Agreed, personally I like it more than seccomp->flags.

But probably it would be better to place the new member before/after
other bitfields to save the space?

Oleg.

