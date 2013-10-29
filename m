Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3J2JiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:38:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37800 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983Ab3J2JiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:38:16 -0400
Date: Tue, 29 Oct 2013 10:32:29 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sachin.kamat@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: mv_xor: Use high_base mmio where appropriate
Message-ID: <20131029103229.5e095a24@skate>
In-Reply-To: <20131029083407.GA2416@localhost>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
	<CAPcyv4iQVoYCXz16T3N4MbdVJV7MoKKeL0wq9t9WF1Kf3gz3Bw@mail.gmail.com>
	<20131029083407.GA2416@localhost>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan, Ezequiel,

On Tue, 29 Oct 2013 05:34:08 -0300, Ezequiel Garcia wrote:

> > On Mon, Oct 28, 2013 at 3:54 PM, Ezequiel Garcia
> > <ezequiel.garcia@free-electrons.com> wrote:
> > > Despite requesting two memory resources, called 'base' and 'high_base', the
> > > driver uses explicitly only the former. The latter is being used implicitly
> > > by addressing at offset +0x200, which in practice accesses high_base.
> > >
> > > Instead of relying in such trick, let's define the registers with the
> > > offset from high_base, and use high_base explicitly where appropriate.
> > >
> > > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > > ---
> > >  drivers/dma/mv_xor.c |  3 ++-
> > >  drivers/dma/mv_xor.h | 25 +++++++++++++------------
> > >  2 files changed, 15 insertions(+), 13 deletions(-)
> > 
> > Since it's unused I'd prefer a patch that just deletes xor_high_base.
> > 
> 
> It's wrongly *unused*, the mmio high_base is actually being used
> implicitly by always addressing at an offset that addresses +200.
> 
> Deleting high_base would actually make it worse, for that region
> will no longer be ioremaped. Maybe the commit message is not clear
> about it?

I agree with Ezequiel, and I believe his patch is appropriate. The
registers for the XOR engines are indeed split in two areas, so it
makes sense to have this xor_base / xor_high_base split that reflects
the register mapping passed from the Device Tree, and use this split in
the macros used to access the registers.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
