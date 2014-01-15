Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAOT14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaAOT1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:27:55 -0500
Date: Wed, 15 Jan 2014 20:28:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, holt@sgi.com,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and
	SECCOMP_EXT_ACT_TSYNC
Message-ID: <20140115192816.GA19396@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org> <1389645028-17157-2-git-send-email-wad@chromium.org> <20140114192118.GA31411@redhat.com> <CABqD9hYB7d4=cpCaXZms5v8+=SJnYnkmL8biPE5Jz0YQuJ20MQ@mail.gmail.com> <20140115190445.GA18166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115190445.GA18166@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Oleg Nesterov wrote:
>
> I think the
> locking is seriously broken in this series.

And imho seccomp_sync_threads() should fail "safely".

IOW, I think it should do while_each_thread() twice. The first
iteration should just check SECCOMP_MODE_FILTER/is_ancestor()
and fail if necessary. The 2nd one should change other threads.

Btw, it seems that is_ancestor() doesn't need the NULL check,
it is not called if SECCOMP_MODE_DISABLED ?

Oleg.

