Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaCKQWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:22:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:34816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbaCKQWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:22:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,631,1389772800"; 
   d="scan'208";a="489871944"
Message-ID: <531F365B.4060000@linux.intel.com>
Date: Tue, 11 Mar 2014 09:14:19 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>	<CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>	<CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>	<CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>	<CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>	<CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>	<CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com> <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
In-Reply-To: <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 08:30 AM, Linus Torvalds wrote:
> On Tue, Mar 11, 2014 at 7:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> I wonder if we can actually detect buggy glibc versions at runtime.
> 
> No, don't do that. That way lies madness.
> 
> What might be acceptable then is to just keep the old config name, and
> if the COMPAT_VDSO config is enabled, you just disable the non-compat
> vdso. At least that way, presumably any opensuse people would have
> their kernel config continue working.
> 
> Then if people have that enabled but didn't  need it, you can enable
> it at runtime with
> 
>     echo 1 > /proc/sys/abi/vsyscall32
> 
> which presumably would need to be exposed on 32-bit kernels too (it
> looks like a x86-64-only thing right now)
> 
> The important thing is that we do *not* break user space. Not ever.
> Not knowingly.
> 

As much as I wouldn't mind getting rid of the compat vdso, I really
don't understand why the trivial solution is being ruled out -- the
trivial solution being to just reserve a little more space in the fixmap
area.

I know Andy wants to move the vdso into a normal vma, which I certainly
support, but it is definitely the non-compat case.

	-hpa


