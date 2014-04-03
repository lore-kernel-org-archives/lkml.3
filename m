Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaDCLsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:48:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39559 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbaDCLst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:48:49 -0400
Date: Thu, 3 Apr 2014 12:48:47 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: Get and put regulator of_node
Message-ID: <20140403114847.GQ1665@opensource.wolfsonmicro.com>
References: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140402142356.GE2269@sirena.org.uk> <20140402160438.GO1665@opensource.wolfsonmicro.com> <20140402165354.GG2269@sirena.org.uk> <20140403105804.GP1665@opensource.wolfsonmicro.com> <20140403111431.GU14763@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403111431.GU14763@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 12:14:31PM +0100, Mark Brown wrote:
> On Thu, Apr 03, 2014 at 11:58:04AM +0100, Charles Keepax wrote:
> > The main issue I have is that devm_regualtor_register is a bit
> > awkward. With regulator_register you will always be calling
> > regulator_unregister so you can put the of_node there but with
> > devm there isn't really a good place to put the of_node.
> 
> That's why I suggested it might be OK to take a reference in the core -
> this would allow the device probe to safely drop its reference before it
> returns.
> 
> > Would perhaps a sensible thing here be to add an of_node_get to
> > of_regulator_match, since we seem to be expecting that to
> > increase the ref count. And then just add an of_node_put to
> > regulator_unregister. And for anything directly using
> > regulator_register/devm_regulator_register they should add a
> > manual of_node_get?
> 
> That seems very ugly.

Agreed, it is not exactly made of clean interface success. So I
guess the sensible thing is to add a helper to clean up the
of_regulator_match results and add the node get in the regulator
core as per my original patch. I will fix up the commit message
for it and do patches for the other bits.

Thanks,
Charles
