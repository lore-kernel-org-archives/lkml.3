Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbaGXNtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:49:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:50841 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758923AbaGXNs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:48:57 -0400
Date: Thu, 24 Jul 2014 17:48:28 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Kees Cook <keescook@chromium.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140724134828.GA3553@paralelels.com>
References: <20140703143318.568554771@openvz.org>
 <20140703151102.842945837@openvz.org>
 <20140708190849.GC17860@moon.sw.swsoft.com>
 <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
 <20140708221336.GL17860@moon.sw.swsoft.com>
 <20140709141318.GM17860@moon.sw.swsoft.com>
 <CAGXu5jKmTSb0YmNFDtr-jymrhy_s_PXUuvj3WKYffSU98gwyqg@mail.gmail.com>
 <20140709150604.GN17860@moon.sw.swsoft.com>
 <20140711173625.GD19702@moon>
 <CAGXu5jL3exT4j+8rjMv1O54uJWQ5UHL69Z-24b61rhXROqZamQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <CAGXu5jL3exT4j+8rjMv1O54uJWQ5UHL69Z-24b61rhXROqZamQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:07:51PM -0700, Kees Cook wrote:
> >  - @exe_fd is referred from /proc/$pid/exe and when generating
> >    coredump. We uses prctl_set_mm_exe_file_locked helper to update
> >    this member, so exe-file link modification remains one-shot
> >    action.
> 
> Controlling exe_fd without privileges may turn out to be dangerous. At
> least things like tomoyo examine it for making policy decisions (see
> tomoyo_manager()).
>

We don't want to reduce security. How can we get a process with a
target exe link, which executes our code?

We can execute the target file and attach to it with ptrace. ptrace
allows to inject and execute any code.

So if we are sure that we are able to do a previous scenario, we can
safely change exe-link, can't we?

prctl already has a check of permissions to execute the target file.
If we execute a file. What can prevent us to attach to the process with ptrace?

The file can have a suid bit, so after executing it we may lose ability
to attach to it. To check that we can check that uid and gid is zero
in a current userns (local root).

What else do we need to check?

Thanks,
Andrey
