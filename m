Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbaFQOBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:01:55 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15885 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbaFQOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:01:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 17 Jun 2014 06:56:16 -0700
Date: Tue, 17 Jun 2014 17:01:46 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
 <539F691E.5030204@wwwdotorg.org> <20140617121313.GE18816@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140617121313.GE18816@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:13:15PM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Jun 16, 2014 at 04:01:02PM -0600, Stephen Warren wrote:
> > On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> > > This symbol needs to be exported to power on rails without using
> > > tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
> > > cannot be used in situations where the driver wants to handle clocking
> > > by itself.
> > 
> > Thierry, are you OK with this change?
> 
> I would've preferred tegra_powergate_sequence_power_up() to be used

I don't think the current tegra_powergate_sequence_power_up() API is very well
defined though. I don't think the clocks and resets required by the sequence
should be provided by the driver. For one, there can be several clocks and
resets that need to be controlled for a single domain.

Cheers,

Peter.
