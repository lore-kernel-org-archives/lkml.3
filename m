Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab3BLAvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:51:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:46443 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674Ab3BLAve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:51:34 -0500
Message-ID: <1360630273.2035.2.camel@pasglop>
Subject: Re: [BUG] irq_dispose_mapping after irq request failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Baruch Siach <baruch@tkos.co.il>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:51:13 +1100
In-Reply-To: <20130211205255.72B513E3530@localhost>
References: <20130211053100.GB18462@sapphire.tkos.co.il>
	 <20130211061949.GA5561@concordia> <20130211205255.72B513E3530@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 20:52 +0000, Grant Likely wrote:
> Really the irq mappings should be using reference counting. The existing
> code is naive on this count and just releases the irq on the first call
> to irq_dispose_mapping().  I've not gotten around to fixing that. Anyone
> want to take that task on?

Is this the best approach ?

The original idea was that there was no point disposing of mappings in most
cases and keeping the mapping around would provide a bit of stability of
interrupt numbers which might come in handy for debugging etc...

The few cases where disposing of a mapping might be useful is if the underlying
physical interrupts completely disappear, as in a cascaded controller gets
removed or that sort of thing, which is a very rare case... And even then...

Could you just make irq_dispose_mapping() check if the irq desc is
active and fail/WARN/BUG if it is ? I don't see the point of adding a refcount,
that feels overkill.

Cheers,
Ben.


