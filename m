Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaFBTr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:47:59 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45333 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaFBTrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <1400799936-26499-1-git-send-email-keescook@chromium.org>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
Date: Mon, 2 Jun 2014 12:47:41 -0700
X-Google-Sender-Auth: Wmw5mzrCiYiz86stPh0SKW8IoEM
Message-ID: <CAGXu5jLYPbJKCBvhVxfHEUFeCPJO-OBhRFufUSNy6o1N=LJ6UQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@google.com>, Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Would you be willing to carry this series? Andy Lutomirski appears
happy with it now. (Thanks again for all the feedback Andy!) If so, it
has a relatively small merge conflict with the bpf changes living in
net-next. Would you prefer I rebase against net-next, let sfr handle
it, get carried in net-next, or some other option?

Thanks!

-Kees


On Thu, May 22, 2014 at 4:05 PM, Kees Cook <keescook@chromium.org> wrote:
> This adds the ability for threads to request seccomp filter
> synchronization across their thread group (either at filter attach time
> or later). (For example, for Chrome to make sure graphic driver threads
> are fully confined after seccomp filters have been attached.)
>
> To support this, seccomp locking on writes is introduced, along with
> refactoring of no_new_privs. Races with thread creation are handled via
> the tasklist_list.
>
> I think all the concerns raised during the discussion[1] of the first
> version of this patch have been addressed. However, the races involved
> have tricked me before. :)
>
> Thanks!
>
> -Kees
>
> [1] https://lkml.org/lkml/2014/1/13/795
>
> v5:
>  - move includes around (drysdale)
>  - drop set_nnp return value (luto)
>  - use smp_load_acquire/store_release (luto)
>  - merge nnp changes to seccomp always, fewer ifdef (luto)
> v4:
>  - cleaned up locking further, as noticed by David Drysdale
> v3:
>  - added SECCOMP_EXT_ACT_FILTER for new filter install options
> v2:
>  - reworked to avoid clone races
>



-- 
Kees Cook
Chrome OS Security
