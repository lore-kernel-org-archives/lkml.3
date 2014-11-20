Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbaKTPRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:17:42 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:53612 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaKTPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:17:41 -0500
Date: Thu, 20 Nov 2014 16:17:33 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Niklas Svensson <niklas.svensson@axis.com>
Cc: Paul Burton <paul.burton@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: mips-cm: CM regions are disabled at boot
Message-ID: <20141120151733.GC21620@linux-mips.org>
References: <1416486540-28681-1-git-send-email-niklass@axis.com>
 <20141120123434.GW1127@pburton-laptop>
 <546DF354.6030803@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546DF354.6030803@axis.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:57:40PM +0100, Niklas Svensson wrote:

> On 11/20/2014 01:34 PM, Paul Burton wrote:
> > On Thu, Nov 20, 2014 at 01:29:00PM +0100, Niklas Svensson wrote:
> >> Each CM_REGION_TARGET is set to disabled at boot,
> > 
> > That part is true...
> > 
> >> so there is no need to disable the matching
> >> CM_GCR_REG explicitly.
> > 
> > ...however there is no guarantee that the bootloader, or another kernel,
> > or some other piece of code didn't program the registers differently
> > before Linux starts. So I believe this patch to be incorrect.
> 
> 
> That is the reason for this patch. This will overwrite settings written by the bootloader.
> 
> Say if the bootloader sets up an iocu, then these writes will clear those settings.

The kernel has to be firmware agnostic, can't know how these registers have
been initialized as long as there is no proper boot protocol for the
handover to the kernel which includes this status.  At this point I think a
solution that hands over the required information as part of the DT is
probably the way to go.

  Ralf
