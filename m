Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaBGTou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:44:50 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:63315 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaBGTos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:44:48 -0500
MIME-Version: 1.0
In-Reply-To: <52F52EDA.4080007@linux.intel.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
	<CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
	<52E5EFAF.3060609@linux.intel.com>
	<CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com>
	<52E601DA.7010605@zytor.com>
	<20140130220708.GP9951@redhat.com>
	<CAGXu5jKp0j71ucE7uOWRa+gQM1Wzp=_KdByJK4XnACTwiCW4ow@mail.gmail.com>
	<20140207144914.GA5949@redhat.com>
	<52F52EDA.4080007@linux.intel.com>
Date: Fri, 7 Feb 2014 11:44:47 -0800
X-Google-Sender-Auth: Pdkw1MDtDqJ_KzkRTtwSHo9kkKs
Message-ID: <CAGXu5jKTr1udKiD7mhVEkN2W4z0w687DS=jJMORTT+ny+DqGCg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dave Young <dyoung@redhat.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 11:07 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 02/07/2014 06:49 AM, Vivek Goyal wrote:
>>
>> As a workaround, Dave is currently using "nokaslr" command line parameter
>> for second kernel. He is still facing issues where makedumpfile segment
>> faults. He is looking into it further.
>>
>
> Now, let's state this: kaslr for kdump is almost certainly useless (the
> amount of reserved memory is not enough to provide any meaningful
> randomization, so any randomization needs to happen during the memory
> reservation phase.)  So disabling kaslr in the kdump kernel is entirely
> appropriate.

Peter covered everything already, but yeah, kaslr and kdump may not
make a lot of sense together, but regardless, yes, it only examines
e820 for memory space. It has to do all this work before the kernel
decompresses, so it's very early.

-Kees

-- 
Kees Cook
Chrome OS Security
