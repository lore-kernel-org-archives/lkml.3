Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3LJBGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:06:13 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47936 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3LJBGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:06:11 -0500
MIME-Version: 1.0
In-Reply-To: <52A66190.9060907@zytor.com>
References: <20131210001620.GA7938@www.outflux.net>
	<52A66190.9060907@zytor.com>
Date: Mon, 9 Dec 2013 17:06:10 -0800
X-Google-Sender-Auth: uV5EXaCjYJ5AxINFmTeAO2JdlIc
Message-ID: <CAGXu5jKkCNWQKH-Ozm72C3aY_NBzRdNo2GmqKbVVJds5xs=SXg@mail.gmail.com>
Subject: Re: [PATCH v2] kexec: add sysctl to disable kexec
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, Rob Landley <rob@landley.net>,
        Eric Biederman <ebiederm@xmission.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 4:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/09/2013 04:16 PM, Kees Cook wrote:
>> For general-purpose (i.e. distro) kernel builds it makes sense to build with
>> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
>> with kexec. However, in the face of trying to lock down a system with such
>> a kernel, there needs to be a way to disable kexec (much like module loading
>> can be disabled). Without this, it is too easy for the root user to modify
>> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are set.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Acked-by: Rik van Riel <riel@redhat.com>
>
> So the logic is to load a crashkernel and then lock down the machine
> before services, networking etc. are enabled?

Right, or to just turn it off at boot time if kexec will not be used at all.

-Kees

-- 
Kees Cook
Chrome OS Security
