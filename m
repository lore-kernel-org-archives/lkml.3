Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3LJPzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:55:39 -0500
Received: from one.firstfloor.org ([193.170.194.197]:38214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3LJPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:55:36 -0500
Date: Tue, 10 Dec 2013 16:55:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Do Intel microcode revision check
 signed
Message-ID: <20131210155533.GI21717@two.firstfloor.org>
References: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
 <20131210153000.GA3804@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210153000.GA3804@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:30:00AM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Dec 06, 2013 at 01:04:02PM -0800, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The Intel SDM Vol 3 9.11.1 Microcode update states that
> > the update revision field is signed. However we do the comparison
> > unsigned, as the comparison gets promoted.
> > 
> > Use a cast to really do a signed comparison of the microcode
> > revision.
> 
> Why not just update the struct?

It would need updating various printks I think. So I chose the simpler cast,
as that already solves the comparison problem.

-Andi
