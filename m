Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaDOGAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:00:44 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:39468 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOGAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:00:42 -0400
Date: Tue, 15 Apr 2014 08:00:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140415060038.GA29649@gmail.com>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
 <20140409060133.GA6766@gmail.com>
 <20140409081709.GA283@x4>
 <20140414103205.GA2846@gmail.com>
 <20140415010003.GA2765@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415010003.GA2765@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

> > and it slows down kernel development'.
>
> No, it doesn't slow down development builds; it makes kernel builds 
> slower if and only if LTO is turned on, which most kernel developers 
> won't need to do.
>
> On the other hand, distro and embedded kernels can do so for final 
> builds, and developers pushing to minimize the kernel can turn it on 
> for their own work as needed.

1)

If LTO will be as fragile for the kernel as it is for user space, then 
low level developers will be advised to enable it during testing.

2)

Developers and testers tend to clone distro configs to get to a 
working .config: via 'make localconfig' and similar methods. This 
means that options like this tend to spread into development 
environments.

I saw that with DEBUG_INFO frequently: I detest the option with a 
passion because it's such a drag on build time (but not as slow as 
LTO), still time and time again it shows up in a .config of mine.

So the "it does not slow down development" argument is simply not 
true. It clearly has such a cost.

LTO might still be a net win in the end, if the upsides are strong 
enough, but I am wary of arguments that try to ignore or underestimate 
the weak points.

Thanks,

	Ingo
