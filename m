Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3F1UEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:04:05 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38717 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3F1UEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:04:02 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC PATCH] kernel/signal.c: avoid BUG_ON with SIG128 (MIPS)
Date: Fri, 28 Jun 2013 22:03:56 +0200
User-Agent: KMail/1.8.2
Cc: Oleg Nesterov <oleg@redhat.com>, David Daney <ddaney.cavm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
References: <1369846916-13202-1-git-send-email-james.hogan@imgtec.com> <20130529173634.GA2020@redhat.com> <CAAG0J9_yJd5mf0t7whnKDYtf0AdZDnErjOgUga7t0p3TEL_9YQ@mail.gmail.com>
In-Reply-To: <CAAG0J9_yJd5mf0t7whnKDYtf0AdZDnErjOgUga7t0p3TEL_9YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306282203.56255.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 May 2013 23:56, James Hogan wrote:
> On 29 May 2013 18:36, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 05/29, David Daney wrote:
> >>
> >> On 05/29/2013 10:01 AM, James Hogan wrote:
> >>> MIPS has 128 signals, the highest of which has the number 128. The
> >>
> >> I wonder if we should change the ABI and reduce the number of signals to
> >> 127 instead of this patch.
> >
> > Same thoughts...
> 
> I'll give it a try. I wouldn't have thought it'd break anything, but
> you never know. glibc (incorrectly) sets [__]SIGRTMAX to 127 already.
> On the other hand uClibc sets it to 128, so anything built against
> uClibc that uses signals SIGRTMAX-n (where n may be 0) or uses an
> excessive number of rt signals starting from SIGRTMIN (sounds
> unlikely) could well need an updated uClibc (or a full rebuild if it's
> crazy enough to use __SIGRTMAX).

Fixed in uclibc git: _NSIG is 128, __SIGRTMAX is 127
(_NSIG in libc is not the same as in kernel, but +1).

While at it, added extensive comment why it is so.
