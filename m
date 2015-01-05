Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbbAERqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:46:19 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:37929 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbAERqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:46:18 -0500
Date: Mon, 5 Jan 2015 18:46:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: Purcareata Bogdan <b43198@freescale.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
Message-ID: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AA9C4D.3000001@freescale.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I was curious why the mpic_cpu_read(MPIC_INFO(CPU_WHOAMI)) was there in
> the first place and if it's still needed. If it's still required, I
> guess a better approach is to eliminate the call only if the kernel is
> running on the KVM guest side, where the MPIC is emulated and no longer
> requires a readback.

"Why not?"

A mechanism being "emulated"/"virtual" or not
may not necessarily be much of a distinction (if at all!).
The readback might be required
to properly fulfill all requirements
of a full state change protocol specification,
which might easily be the case for both RS(*) and virtual hardware.
And especially for virtual hardware
such a "readback" event
might be an extremely important "end of transaction" marker
which may often be needed for freeing of temporary resources etc.

I'm talking out of my *ss without any MPIC specifics here
(and especially not why the readback there actually is needed -
if that doesn't happen to be the case for PCI Posting reasons or some such),
but it's just intended as food for thought :)

*) Real Silicon (rather than RL - Real Life)

HTH,

Andreas Mohr
