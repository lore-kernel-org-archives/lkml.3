Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaDGXHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:07:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:21382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaDGXHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,813,1389772800"; 
   d="scan'208";a="488819210"
Date: Mon, 7 Apr 2014 13:42:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Thomas =?iso-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org,
        matt.fleming@intel.com, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
Message-ID: <20140407204221.GW32556@tassilo.jf.intel.com>
References: <52E4CF03.8030208@archlinux.org>
 <5339F739.2060207@archlinux.org>
 <20140331233450.GI32556@tassilo.jf.intel.com>
 <5339FC62.8060207@archlinux.org>
 <20140405011332.GR32556@tassilo.jf.intel.com>
 <5340134B.4010705@archlinux.org>
 <20140407173016.GU32556@tassilo.jf.intel.com>
 <5342E46B.4080603@archlinux.org>
 <53430646.40507@archlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53430646.40507@archlinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:10:46PM +0200, Thomas Bächler wrote:
> Am 07.04.2014 19:46, schrieb Thomas Bächler:
> > Am 07.04.2014 19:30, schrieb Andi Kleen:
> >>>> Do you have a specific config?
> >>>> Specific compiler version?
> >>>
> >>> Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux 3.14.
> >>
> >> I tested this configuration (with gcc 4.8 on FC20/19) and it loads
> >> ext4 and all the other modules without any problems.
> >>
> >> Base tree: 
> >>
> >> commit e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0
> >> Merge: c0fc3cb 9dd721c
> >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date:   Mon Mar 31 12:34:49 2014 -0700
> >>
> >> Must be something really archlinux specific. Please do some debugging.
> >> Also please double check that all your test procedures are correct.
> > 
> > Tetsuo was so kind to install Arch Linux and reproduce the exact
> > procedure I use to create the kernel (which includes the automated
> > creation of a pristine build environment) - his kernel booted just fine.
> > I will do more tests today on two of my own computers to narrow this down.
> 
> I think I found out why nobody could reproduce the problem.
> 
> I did a few more tests and it turns out that the problem only occurs
> when I boot the kernel with UEFI (using Gummiboot+EFISTUB). Now, except
> for OVMF virtual machines, there are barely any 32 Bit UEFI machines
> around, so nobody noticed. When I boot the kernel with 32 Bit BIOS, it
> boots fine.
> 
> Just to clarify: As mentioned in my first mail, some symbols still get a
> 0x0 CRC (which I still think is wrong), but the mismatch does not occur
> in BIOS mode.
> 
> On x86_64, the problem does not occur at all.

Thanks.

This sounds like the UEFI boot corrupts some memory? 

Copying some UEFI experts.

Maybe we need some CRC checksum checking in the kernel?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
