Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaFQQOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:14:52 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:63353 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaFQQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:14:50 -0400
Date: Tue, 17 Jun 2014 12:14:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 8/9] ata: Add support for the Tegra124 SATA controller
Message-ID: <20140617161447.GH31819@htj.dyndns.org>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1401881559-18469-9-git-send-email-mperttunen@nvidia.com>
 <1470404.13mIFv0Hnj@amdc1032>
 <53A0686F.4000303@wwwdotorg.org>
 <20140617161320.GG31819@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617161320.GG31819@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:13:20PM -0400, Tejun Heo wrote:
> On Tue, Jun 17, 2014 at 10:10:23AM -0600, Stephen Warren wrote:
> > > sata_writel() and sata_read() static inlines don't seem to add any value.
> > > 
> > > Can they be removed?
> > 
> > Such functions are quite idiomatic in drivers, and serve to simplify all
> > the call-sites by removing the need to write out the addition of the
> > base address everywhere.
> 
> I think it obfuscates more than helps.  If you absoluately have to
> keep it, please at least name it so that it's clear that it's
> something specific to this driver.

Please also drop inline.  It isn't a difficult optimization to perform
for the compiler.

-- 
tejun
