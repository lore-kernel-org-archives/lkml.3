Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaE3KiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:38:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:37774 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaE3KiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:38:21 -0400
Message-ID: <1401446278.14938.26.camel@pasglop>
Subject: Re: Bad DMA from Marvell 9230
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>
Cc: Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 30 May 2014 20:37:58 +1000
In-Reply-To: <20140530030618.5ad4f447@Vantage>
References: <1395903457.5569.89.camel@pasglop>
	 <20140530030618.5ad4f447@Vantage>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 03:06 -0400, Jérôme Carretero wrote:
> On Thu, 27 Mar 2014 17:57:37 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > I've been trying a 9230 on a power box here (a 9235 on the same
> > machine works fine) and it blows up with an IOMMU violation early
> > during init.
> 
> Hi,
> 
> That's https://bugzilla.kernel.org/show_bug.cgi?id=42679
> if you haven't already found it.

Somewhat... It's not the phantom function, the error I capture in my
IOMMU shows that it's trying to read from address 0 which is unmapped
but with the right initiator.

This device is a pile of crap. We've talked to Marvell support channel,
sent driver traces etc... but they didn't admit anything.

We've switched to a 9235 instead which seems to work fine.

Cheers,
Ben.


