Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903Ab3DDUyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:54:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35264 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761637Ab3DDUyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <515DDEC0.9000109@zytor.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<515DDEC0.9000109@zytor.com>
Date: Thu, 4 Apr 2013 13:54:36 -0700
X-Google-Sender-Auth: dbh7pm7fRcxjkgoihhUP0-Ks6rA
Message-ID: <CAGXu5j+FqZpXURougB_Sd4zmF3bsqsT=m-om5eEM5WCsRX014g@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/04/2013 01:07 PM, Kees Cook wrote:
>> However, the benefits of
>> this feature in certain environments exceed the perceived weaknesses[2].
>
> Could you clarify?

I would summarize the discussion of KASLR weaknesses into to two
general observations:
1- it depends on address location secrecy and leaks are common/easy.
2- it has low entropy so attack success rates may be high.

For "1", as Julien mentions, remote attacks and attacks from a
significantly contained process (via seccomp-bpf) minimizes the leak
exposure. For local attacks, cache timing attacks and other things
also exist, but the ASLR can be improved to defend against that too.
So, KASLR is useful on systems that are virtualization hosts,
providing remote services, or running locally confined processes.

For "2", I think that the comparison to userspace ASLR entropy isn't
as direct. For userspace, most systems don't tend to have any kind of
watchdog on segfaulting processes, so a remote attacker could just
keep trying an attack until they got lucky, in which case low entropy
is a serious problem. In the case of KASLR, a single attack failure
means the system goes down, which makes mounting an attack much more
difficult. I think 8 bits is fine to start with, and I think start
with a base offset ASLR is a good first step. We can improve things in
the future.

-Kees

--
Kees Cook
Chrome OS Security
