Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaKTXIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:08:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:37198 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbaKTXIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:08:40 -0500
Message-ID: <1416524879.5704.55.camel@kernel.crashing.org>
Subject: Re: [PATCH] of/address: Don't throw errors on absent ranges
 properties
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Nov 2014 10:07:59 +1100
In-Reply-To: <20141119103140.2B9F4C40551@trevor.secretlab.ca>
References: <1415948303.666.50.camel@kernel.crashing.org>
	 <20141118165739.7382AC40966@trevor.secretlab.ca>
	 <1416364351.5704.22.camel@kernel.crashing.org>
	 <20141119103140.2B9F4C40551@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-19 at 10:31 +0000, Grant Likely wrote:
> was my explanation being full of crap. It's my i2c
> > _controller_ which is a platform device, and is on the xscom bus
> which
> > isn't directly MMIO translatable.
> 
> Okay, that makes more sense, but if xscom is a different bus with
> different access methods, then why is it using platform_bus_type? I
> would expect it to have it's own bus_type and container for struct
> device.

There is no point really. It's not really a bus we expose as such to
Linux (mostly the FW uses it) though we use the xscom nodes as chip
nodes.

We do expose selected devices we pick from underneath xscom such
as the LPC bus and the i2c controllers as platform devices which then
use FW interfaces to perform the actual LPC or i2c accesses.

Creating a dedicated bus type would be completely pointless.

The FW itself uses what's there more intensively.

> > The patch still stands :)
> 
> Indeed, I merged it yesterday. :)

Thanks!

Cheers,
Ben.


