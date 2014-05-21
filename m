Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaEUFce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:32:34 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:33285 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaEUFcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:32:33 -0400
Date: Wed, 21 May 2014 08:31:54 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH] openrisc: irq: use irqchip framework
Message-ID: <20140521053153.GA26431@chokladfabriken.org>
References: <1400502328-23974-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <537A18E9.4010301@southpole.se>
 <20140519195433.GA18318@chokladfabriken.org>
 <537AFA18.7050705@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537AFA18.7050705@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 08:45:44AM +0200, Jonas Bonn wrote:
> On 05/19/2014 09:54 PM, Stefan Kristiansson wrote:
> > On Mon, May 19, 2014 at 04:44:57PM +0200, Jonas Bonn wrote:
> > 
> >> ii) Put a Depends on CONFIG_ARCH_OPENRISC in the Kconfig
> > 
> > Hmm, do we really need that?
> > The irqchip driver will picked by 'select'ing it from arch/openrisc/Kconfig
> > So, it won't really be exposed to anyone not explicitly picking it like that.
> > 
> 
> It will be exposed by allyesconfig.

allyesconfig is still ARCH specific, so it will not be exposed by that.

> The driver uses mfspr which is
> openrisc-only, so the driver really needs to hide behind an
> openrisc-arch config option.
> 

Yes, I understand that this needs to be OpenRISC only,
but usually it is frown upon adding things to the Kconfig that are implied
by the default behaviour.
And I believe the default behaviour does imply this, OpenRISC will be the
only ARCH that will pick this driver.

Stefan
