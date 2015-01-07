Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbbAGPpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:45:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:55647 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbbAGPo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:44:59 -0500
Message-ID: <1420641876.5830.32.camel@kernel.crashing.org>
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Andreas Mohr <andi@lisas.de>, Purcareata Bogdan <b43198@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Jan 2015 15:44:36 +0100
In-Reply-To: <1420481454.4961.16.camel@freescale.com>
References: <20150105174616.GA3159@rhlx01.hs-esslingen.de>
	 <1420481454.4961.16.camel@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 12:10 -0600, Scott Wood wrote:
> It would have been nice if a code comment explained why it was doing the
> readback...  I don't see any particular need to wait for EOI completion
> here (unlike when masking).

The EOI is what causes the MPIC to drop it's EE output to the CPU, if the
EOI is processed too slowly & asynchronously (posted write + 33Mhz MPIC)
we observe cases of spurrious interrupts. We had some macs basically getting
a spurrious irq for every MPIC interrupts...

Cheers,
Ben.


