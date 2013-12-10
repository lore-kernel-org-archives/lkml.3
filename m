Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3LJAP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:15:26 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:40535 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3LJAPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:15:25 -0500
MIME-Version: 1.0
In-Reply-To: <52A657EC.6080304@redhat.com>
References: <20131209233829.GA3501@www.outflux.net>
	<52A657EC.6080304@redhat.com>
Date: Mon, 9 Dec 2013 16:15:24 -0800
X-Google-Sender-Auth: 7hU0Q7VqlQxxXIK8Mb0kB2Iz4EU
Message-ID: <CAGXu5jKi=QeiN=Sipumwi1AR25=ciPC+KAe3XUUQkm31EDexsA@mail.gmail.com>
Subject: Re: [PATCH] kexec: add sysctl to disable kexec
From: Kees Cook <keescook@chromium.org>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 3:53 PM, Rik van Riel <riel@redhat.com> wrote:
> On 12/09/2013 06:38 PM, Kees Cook wrote:
>> For general-purpose (i.e. distro) kernel builds it makes sense to build with
>> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
>> with kexec. However, in the face of trying to lock down a system with such
>> a kernel, there needs to be a way to disable kexec (much like module loading
>> can be disabled). Without this, it is too easy for the root user to modify
>> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are set.
>
> Not everybody will be running with selinux, or another LSM security
> policy, so having this simple knob probably makes sense.
>
> OTOH, are the people who run without a fancy security people the
> same people who are interested in locking down the system?
>
> I guess I'll ack the patch, since I see no real downside to having
> the knob...

Thanks! Yeah, there are cases of machines that are trying to be as
locked down as possible while still not having secure boot, etc. This
helps raise the bar for them.

>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks! I'm sending a v2 since I spaced out on updating the sysctl docs.

-Kees

-- 
Kees Cook
Chrome OS Security
