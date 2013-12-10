Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3LJQeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:34:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48960 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab3LJQeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:34:13 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131210143540.GA13909@redhat.com>
References: <20131210001620.GA7938@www.outflux.net> <52A66190.9060907@zytor.com> <CAGXu5jKkCNWQKH-Ozm72C3aY_NBzRdNo2GmqKbVVJds5xs=SXg@mail.gmail.com> <20131210143540.GA13909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 10 Dec 2013 08:32:38 -0800
To: Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rob Landley <rob@landley.net>, Eric Biederman <ebiederm@xmission.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        kexec@lists.infradead.org
Message-ID: <f4fbae55-7d7b-400d-b50f-258002371368@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Of course it isn't.

Vivek Goyal <vgoyal@redhat.com> wrote:
>On Mon, Dec 09, 2013 at 05:06:10PM -0800, Kees Cook wrote:
>> On Mon, Dec 9, 2013 at 4:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 12/09/2013 04:16 PM, Kees Cook wrote:
>> >> For general-purpose (i.e. distro) kernel builds it makes sense to
>build with
>> >> CONFIG_KEXEC to allow end users to choose what kind of things they
>want to do
>> >> with kexec. However, in the face of trying to lock down a system
>with such
>> >> a kernel, there needs to be a way to disable kexec (much like
>module loading
>> >> can be disabled). Without this, it is too easy for the root user
>to modify
>> >> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled
>are set.
>> >>
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> Acked-by: Rik van Riel <riel@redhat.com>
>> >
>> > So the logic is to load a crashkernel and then lock down the
>machine
>> > before services, networking etc. are enabled?
>> 
>> Right, or to just turn it off at boot time if kexec will not be used
>at all.
>
>kdump kernel is loaded with the help of kdump service. Different
>distro's
>might have different dependencies for that serivce. But recently in
>fedora
>we wait network to come up before starting that service. (So that nfs
>targets can be mounted and checked for valid dump destinations).
>
>IOW, crash kernel is loaded quite late in the game (quite a few
>services
>have run and possibly networking is up too). To me, practically one
>will
>disable kdump also if you change state of this knob early.
>
>Thanks
>Vivek

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
