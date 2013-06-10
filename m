Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3FJJKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:10:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3FJJKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:10:36 -0400
Date: Mon, 10 Jun 2013 10:10:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Chris Johnson <CJohnson@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
Message-ID: <20130610091012.GR18614@n2100.arm.linux.org.uk>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <20130606110240.GA3320@localhost.localdomain> <CAAVeFu+o7oc4Rrn67xxzsgeZ9xrTBkaLd_E4amaVgcNBRsKC_g@mail.gmail.com> <20130607173004.GA29344@localhost.localdomain> <CAAVeFuJuf2hrMaM5keoai65vAAg6JLrjDUvYm4e2zQvsw64_8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuJuf2hrMaM5keoai65vAAg6JLrjDUvYm4e2zQvsw64_8A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 04:47:22PM +0900, Alexandre Courbot wrote:
> One could remove the naked attribute and put there registers into the
> clobber list, but then the function will be inlined and we will have
> to ensure the parameters end up in the right register (and having a
> function that cannot be inlined is convenient in that respect). So as
> far as I can tell, having the function naked and saving the registers
> ourselves seems to be the most convenient way around this.

If you use such a large clobber list, you risk the compiler barfing on
you that it's run out of registers.
