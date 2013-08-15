Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3HOWtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:49:13 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33929 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3HOWtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130815223917.27890.28003.stgit@bling.home>
References: <20130815223917.27890.28003.stgit@bling.home>
Date: Fri, 16 Aug 2013 08:49:10 +1000
Message-ID: <CAPM=9twr6Ho7PCFdL9GubzDNPedO9tBvC1YPofpkJ01Avx=8_g@mail.gmail.com>
Subject: Re: [PATCH] i915: Update VGA arbiter support for newer devices
From: Dave Airlie <airlied@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 8:43 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> This is intended to add VGA arbiter support for Intel HD graphics on
> Core processors.  The old GMCH registers no longer exist, so even
> though it appears that i915 participates in VGA arbitration, it doesn't
> work.  On Intel HD graphics we already attempt to disable VGA regions
> of the device.  This makes registering as a VGA client unnecessary since
> we don't intend to operate differently depending on how many VGA devices
> are present.  We can disable VGA memory regions by clearing a memory
> enable bit in the VGA MSR.  That only leaves VGA IO, which we update
> the VGA arbiter to know that we don't participate in VGA memory
> arbitration.  We also add a hook on unload to re-enable memory and
> reinstate VGA memory arbitration.

I would think there is still a VGA disable bit on the Intel device
somewhere, we'd just need
Intel to look in the docs and find it. A bit that can nuke both i/o
and cmd regs.

Dave.
