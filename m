Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3B1XCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:02:36 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39181 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab3B1XCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302282251200.5210@kaball.uk.xensource.com>
References: <20130228215640.GA3136@www.outflux.net>
	<alpine.DEB.2.02.1302282251200.5210@kaball.uk.xensource.com>
Date: Thu, 28 Feb 2013 15:02:29 -0800
X-Google-Sender-Auth: N-_U0EZNNlcdpoYRZ547gA4EYx8
Message-ID: <CAGXu5jKHR+bnx7jc0vC15sJL1rradGt0g230MVOaDLj5NqCBhQ@mail.gmail.com>
Subject: Re: [PATCH v2] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 2:53 PM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Thu, 28 Feb 2013, Kees Cook wrote:
>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
>> while now and is almost always enabled by default. As agreed during the
>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>
>> v2:
>>  - drop EXPERIMENTAL from bool and help text too.
>>
>> ---
>>  arch/x86/xen/Kconfig |    8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
>> index 93ff4e1..6c5802f 100644
>> --- a/arch/x86/xen/Kconfig
>> +++ b/arch/x86/xen/Kconfig
>> @@ -52,12 +52,10 @@ config XEN_DEBUG_FS
>>         Enabling this option may incur a significant performance overhead.
>>
>>  config XEN_X86_PVH
>> -     bool "Support for running as a PVH guest (EXPERIMENTAL)"
>> -     depends on X86_64 && XEN && EXPERIMENTAL
>> +     bool "Support for running as a PVH guest"
>> +     depends on X86_64 && XEN
>>       default n
>>       help
>>          This option enables support for running as a PVH guest (PV guest
>>          using hardware extensions) under a suitably capable hypervisor.
>> -        This option is EXPERIMENTAL because the hypervisor interfaces
>> -        which it uses is not yet considered stable therefore backwards and
>> -        forwards compatibility is not yet guaranteed.  If unsure, say N.
>> +        If unsure, say N.
>
> Please do not change the text this way.
> The fact that CONFIG_EXPERIMENTAL is going away it doesn't change the
> fact that this feature is experimental.
> Maybe you want to replace EXPERIMENTAL with experimental, or if
> experimental has become as taboo word, I am sure you can find a suitable
> synonym.

Ah, sorry, I misunderstood what was being recommended from the other
thread (quoting below...)

On Sat, 23 Feb 2013, Konrad Rzeszutek Wilk wrote:
> It certainly is unstable right now (which is why it was unstaged from
> the v3.9 train). I hope that by v3.10 it won't be - at which
> point this patch (and the EXPERIMENTAL) makes sense.

Only "depends on EXPERIMENTAL" must go away. Did you want either the
bool or help text to go away too? If neither, my original patch should
work. If you only want the bool text gone, I can send that version
instead.

-Kees

--
Kees Cook
Chrome OS Security
