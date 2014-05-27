Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaE0U33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:29:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:53938 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaE0U31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:29:27 -0400
Message-ID: <1401222210.20915.79.camel@pasglop>
Subject: Re: [PATCH v2 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 06:23:30 +1000
In-Reply-To: <20140527193425.GC30751@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
	 <1401054470.3958.30.camel@pasglop> <20140527193425.GC30751@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 20:34 +0100, Will Deacon wrote:

> Do you mean the io{read,write} functions? Funnily enough, they're already
> relaxed on ARM if you go by the semantics I've proposed. That implies we at
> least need some Documentation to that effect...
> 
> What do you do on ppc?

They are not supposed to be relaxed. If they are, you probably have a
whole lot of busted drivers :-)

They have the same semantics as readl/writel for memory and as inb/outb
for IO space, they just allow to hide the "type" (memory vs. IO) from
most of the driver code.

We probably need to create a set of _relaxed variants.

Cheers,
Ben.


