Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbaD1Tp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbaD1Tp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:45:26 -0400
Message-ID: <1398714297.3010.79.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: fixmap: fix missing sub-page offset for
 earlyprintk
From: Mark Salter <msalter@redhat.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Date: Mon, 28 Apr 2014 15:44:57 -0400
In-Reply-To: <1398711006-14943-1-git-send-email-marc.zyngier@arm.com>
References: <1398711006-14943-1-git-send-email-marc.zyngier@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 19:50 +0100, Marc Zyngier wrote:
> Commit d57c33c5daa4 (add generic fixmap.h) added (among other
> similar things) set_fixmap_io to deal with early ioremap of devices.
> 
> More recently, commit bf4b558eba92 (arm64: add early_ioremap support)
> converted the arm64 earlyprintk to use set_fixmap_io. A side effect of
> this conversion is that my virtual machines have stopped booting when
> I pass "earlyprintk=uart8250-8bit,0x3f8" to the guest kernel.
> 
> Turns out that the new earlyprintk code doesn't care at all about
> sub-page offsets, and just assumes that the earlyprintk device will
> be page-aligned. Obviously, that doesn't play well with the above example.
> 
> Further investigation shows that set_fixmap_io uses __set_fixmap instead
> of __set_fixmap_offset. A fix is to introduce a set_fixmap_offset_io that
> uses the latter, and to remove the superflous call to fix_to_virt
> (which only returns the value that set_fixmap_io has already given us).
> 
> With this applied, my VMs are back in business. Tested on a Cortex-A57
> platform with kvmtool as platform emulation.
> 
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---

Acked-by: Mark Salter <msalter@redhat.com>


