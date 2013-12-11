Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3LKVNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:13:35 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45889 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3LKVNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:13:33 -0500
MIME-Version: 1.0
In-Reply-To: <87vbyvxojs.fsf@xmission.com>
References: <20131210001620.GA7938@www.outflux.net>
	<87vbyvxojs.fsf@xmission.com>
Date: Wed, 11 Dec 2013 13:13:32 -0800
X-Google-Sender-Auth: yxCaGKCey-x9k-rxOnaANAdh9lo
Message-ID: <CAGXu5j+hCf8zkO3FEJ=ZO++unnpzL8GLivSNqy=dYFzJah0WCg@mail.gmail.com>
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, Rob Landley <rob@landley.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 9:52 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> For general-purpose (i.e. distro) kernel builds it makes sense to build with
>> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
>> with kexec. However, in the face of trying to lock down a system with such
>> a kernel, there needs to be a way to disable kexec (much like module loading
>> can be disabled). Without this, it is too easy for the root user to modify
>> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are
>> set.
>
> So let me get this straight.  You object to what happens in sys_reboot
> so you patch sys_kexec_load?

Yes; it's the entry point for loading the image used for crashes and
LINUX_REBOOT_CMD_KEXEC.

> You give someone the privilege to boot whatever they want and yet you
> don't want to support them booting whatever they want?
>
> I'm sorry my brain is hurting trying to understand the logic of this
> patch.

I'm not trying to claim this fixes all attack vectors from a root
user. That is exceedingly hard. :) However, kexec gives the root user
a trivial (and undetectable) way to modify the running kernel.
Providing an option to block sys_kexec_load for systems that will
never use it (or will use it once at startup) is valuable in several
situations. There's no reason to make an attacker's job easier, and
this doesn't get in any one else's way.

-Kees

-- 
Kees Cook
Chrome OS Security
