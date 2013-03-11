Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3CKStZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:49:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48425 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3CKStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:49:23 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 11 Mar 2013 11:49:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Konrad Vrba <konrad.vrba@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: very strange dependencies on CONFIG_EXPERT=n in kernel 3.8
Message-ID: <20130311184916.GA6185@jtriplet-mobl1>
References: <CAF2Nc0zT5t_YeqzJWprUH7ma3_3LCWVXgbxLBODU7drgauDt=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF2Nc0zT5t_YeqzJWprUH7ma3_3LCWVXgbxLBODU7drgauDt=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 04:14:27PM +0100, Konrad Vrba wrote:
> Dear list,
> I have noticed that CONFIG_EXPERT=n makes the following options in the
> kernel required (unremovable):
> 
> CONFIG_FW_LOADER=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> CONFIG_I8253_LOCK=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_PCSPKR_PLATFORM=y
> 
> If I select CONFIG_EXPERT=y then I can remove those, but that creates
> a new problem by making CONFIG_DEBUG_KERNEL=y unremovable.
> 
> To make a specific example, this makes it impossible to compile a kernel with
> CONFIG_FW_LOADER=n
> CONFIG_DEBUG_KERNEL=n
> at the same time

CONFIG_DEBUG_KERNEL, like CONFIG_EXPERT, should not directly affect the
code included in the kernel; it should just avoid asking about a pile of
other debugging options.  In practice, a small amount of
architecture-specific code (for powerpc, parisc, and blackfin) did use
it as a generic debug option, but that needs fixing.  So, for now, turn
on CONFIG_EXPERT and live with having CONFIG_DEBUG_KERNEL turned on.

That aside, several of the above options should not depend on EXPERT;
why would PCSPKR_PLATFORM or DEBUG_MEMORY_INIT need to depend on EXPERT?

- Josh Triplett
