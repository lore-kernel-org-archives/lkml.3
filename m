Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaGITBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbaGITBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:01:34 -0400
Date: Wed, 9 Jul 2014 20:59:36 +0200
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
Subject: Re: [PATCH v9 09/11] seccomp: introduce writer locking
Message-ID: <20140709185936.GA6043@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org> <1403911380-27787-10-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403911380-27787-10-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Kees Cook wrote:
>
>  void put_seccomp_filter(struct task_struct *tsk)
>  {
> -	struct seccomp_filter *orig = tsk->seccomp.filter;
> +	struct seccomp_filter *orig = smp_load_acquire(&tsk->seccomp.filter);
>  	/* Clean up single-reference branches iteratively. */
>  	while (orig && atomic_dec_and_test(&orig->usage)) {

And this smp_load_acquire() looks unnecessary. atomic_dec_and_test()
is a barrier.

Oleg.

