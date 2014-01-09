Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaAIPre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:47:34 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12695 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752580AbaAIPr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:47:26 -0500
Message-ID: <1389282443.23721.51.camel@hornet>
Subject: Re: [RFC 06/18] regmap: Formalise use of non-bus context
From: Pawel Moll <pawel.moll@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 09 Jan 2014 15:47:23 +0000
In-Reply-To: <20140109133456.GN31886@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	 <1387815830-8794-7-git-send-email-pawel.moll@arm.com>
	 <20131224124538.GZ30815@sirena.org.uk> <1389272911.23721.49.camel@hornet>
	 <20140109133456.GN31886@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 13:34 +0000, Mark Brown wrote:
> > First of all, it's just a generalization of the free_context already
> > existing in regmap_bus (and used by regmap-mmio). And in case of this
> > series it is being used to release extra resource added allocated for a
> > "busless" regmap_config. Briefly, I'm using devm_regmap_init() to
> > "attach" a custom regmap configuration to a device when it is being
> > created (which is then dev_get_regmap()-ed in the driver, as you saw in
> > the regulator patch) and its context is a pointer to kzallocated data.
> > free_context is used to release it when devm resource is being removed.
> 
> > Does it make any sense?
> 
> To be honest not really - the above sounds like you should've allocated
> the memory using devm_kzalloc() or just embedding the allocated data in
> the driver data for the parent.  Internal things need to clean up after
> themselves but users should already have a larger context of some kind.

I've started with regmap_bus so the free_context did fit well like in
regmap-mmio, but you're right - with the current approach I should be
able to simply use devm_kzalloc(). I'll give it a try and if it works,
I'll drop this patch completely.

Paweł

