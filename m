Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366AbaGPQpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:45:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:33945 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645AbaGPQp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:45:27 -0400
Date: Thu, 17 Jul 2014 02:44:20 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
In-Reply-To: <CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1407170243480.22946@namei.org>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org> <20140711164931.GA18473@redhat.com> <CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Kees Cook wrote:

> On Fri, Jul 11, 2014 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 07/10, Kees Cook wrote:
> >>
> >> This adds the ability for threads to request seccomp filter
> >> synchronization across their thread group (at filter attach time).
> >> For example, for Chrome to make sure graphic driver threads are fully
> >> confined after seccomp filters have been attached.
> >>
> >> To support this, locking on seccomp changes via thread-group-shared
> >> sighand lock is introduced, along with refactoring of no_new_privs. Races
> >> with thread creation are handled via delayed duplication of the seccomp
> >> task struct field and cred_guard_mutex.
> >>
> >> This includes a new syscall (instead of adding a new prctl option),
> >> as suggested by Andy Lutomirski and Michael Kerrisk.
> >
> > I do not not see any problems in this version,
> 
> Awesome! Thank you for all the reviews. :) If Andy and Michael are
> happy with this too, I think this is in good shape. \o/
> 
> -Kees

If you re-send this, please add Oleg's Reviewed-by to each patch.


> 
> >
> > Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> >
> 
> 
> 
> 

-- 
James Morris
<jmorris@namei.org>

