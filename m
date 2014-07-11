Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaGKQw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaGKQwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:52:25 -0400
Date: Fri, 11 Jul 2014 18:49:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
Message-ID: <20140711164931.GA18473@redhat.com>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405017631-27346-1-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10, Kees Cook wrote:
>
> This adds the ability for threads to request seccomp filter
> synchronization across their thread group (at filter attach time).
> For example, for Chrome to make sure graphic driver threads are fully
> confined after seccomp filters have been attached.
>
> To support this, locking on seccomp changes via thread-group-shared
> sighand lock is introduced, along with refactoring of no_new_privs. Races
> with thread creation are handled via delayed duplication of the seccomp
> task struct field and cred_guard_mutex.
>
> This includes a new syscall (instead of adding a new prctl option),
> as suggested by Andy Lutomirski and Michael Kerrisk.

I do not not see any problems in this version,

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

