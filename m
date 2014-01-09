Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaAINIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 08:08:38 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46057 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751276AbaAINId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 08:08:33 -0500
Message-ID: <1389272911.23721.49.camel@hornet>
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
Date: Thu, 09 Jan 2014 13:08:31 +0000
In-Reply-To: <20131224124538.GZ30815@sirena.org.uk>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	 <1387815830-8794-7-git-send-email-pawel.moll@arm.com>
	 <20131224124538.GZ30815@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 12:45 +0000, Mark Brown wrote:
> I'd note that I wasn't CCed on most of this series so I'm not entirely
> sure what it's trying to do.

Apologies. The series is quite long and I didn't want to bother too many
people with mostly irrelevant changes. Will copy you on the whole thing
next time.

> > Bus-less maps (ones with reg_read and reg_write functions
> > defined in regmap_config) were given the context passed
> > in regmap_init(), but it was still called "bus_context".
> > 
> > This patch formalises this aspect by renaming it to simple
> > "context" and adds the missing link, free_context function
> > in regmap_config, which allows bus-less maps to use the
> > context in classic way.
> 
> This should be two patches, one patch to do the rename and one to add
> the operation.  

Sure, will do.

> The obvious question here is why is this callback useful
> - what is being allocated in a regmap specific context that needs to be
> lifetime managed separately to the thing doing the creation?  I can't
> see any obvious reason why this would ever get used.

First of all, it's just a generalization of the free_context already
existing in regmap_bus (and used by regmap-mmio). And in case of this
series it is being used to release extra resource added allocated for a
"busless" regmap_config. Briefly, I'm using devm_regmap_init() to
"attach" a custom regmap configuration to a device when it is being
created (which is then dev_get_regmap()-ed in the driver, as you saw in
the regulator patch) and its context is a pointer to kzallocated data.
free_context is used to release it when devm resource is being removed.

Does it make any sense?

Paweł

