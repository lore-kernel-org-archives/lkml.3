Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab3JFJmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 05:42:32 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45813 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3JFJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 05:42:30 -0400
Date: Sun, 6 Oct 2013 11:42:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, bp@suse.de
Subject: Re: [PATCH] x86: Don't make AMD_GART depend on EXPERT and default y
Message-ID: <20131006094227.GC4535@gmail.com>
References: <1380922676-23007-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380922676-23007-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> The AMD_GART driver was made EXPERT/EMBEDDED a long time
> ago to avoid unbootable 64bit systems with 32bit only devices.
> 
> This was before swiotlb was there, which does the job
> of this fallback today. SWIOTLB is always on, so systems
> should always boot.
> 
> The drawback is that every system has to compile that
> driver in (it cannot be a module).
> 
> Also:
> - Newer AMD CPUs (the APUs) don't seem to have AMD_GART support
> at all anymore.
> - Newer AMD platforms have a much better real IOMMU
> - The AMD GART driver was never very good (lots of overhead, e.g.
> in flushing due to some workarounds) and it's doubtful it's really
> better than SWIOTLB.
> - On older K8 systems it didn't even work with all chipsets.
> - The 32bit device bounce buffer case should be rare/
> non performance critical these days anyways.
> - On non AMD systems it is not needed at all.
> 
> So drop the EXPERT dependency on AMD_GART and remove the
> default y. The driver can be still compiled in, just
> it's an explicit decision now, and people who don't want
> it can unselect it.
> 
> I also clarified the description a bit.
> 
> This allows to save ~8K text on most modern x86-64 systems.
> 
> Cc: bp@suse.de
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Btw., this is a perfect changelog!

Thanks,

	Ingo
