Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaIWHVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:21:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:39833 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaIWHVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390198494"
Message-ID: <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86 fixes
From: Matt Fleming <matt.fleming@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 23 Sep 2014 08:20:51 +0100
In-Reply-To: <20140923055802.GA29052@gmail.com>
References: <20140919104021.GA11552@gmail.com>
	 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	 <20140923053510.GB27825@gmail.com> <20140923053711.GA28704@gmail.com>
	 <20140923055802.GA29052@gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 07:58 +0200, Ingo Molnar wrote:
> 
> So if it's the GOT fixup then I feel the safest option is to 
> revert 9cb0e394234d straight away, and then to do a functional 
> revert of f23cf8bd5c1f49 as a separate step, perhaps via 
> something really crude like:
> 
>    #include "../..../drivers/firmware/efi/libstub/efi-stub-helper.c"
> 
> or so. (Maybe someone else can think of something 
> cleaner/simpler, because this method is really ugly, as we'd have 
> to #include the whole libstub library into eboot.c AFAICS...)

Yeah, I think at this point in the release cycle it would be safest to
revert back to the original scheme of #including the .c files. I'm not
sure if we can do any better in a robust way, i.e. without introducing
more regressions. Then take a look at doing the boot stub unification
with fresh eyes (and improved testing) after v3.17.

What I want to avoid is reverting the arm64 side of things too, so I'm
gonna take a stab at doing the necessary reverts/partial
reverts/whatever to get x86 back to the pre-merge window boot stub
duplicated code scheme.

