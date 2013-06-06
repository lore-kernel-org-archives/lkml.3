Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3FFFok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:44:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:36022 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3FFFoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:44:39 -0400
Message-ID: <1370497454.3766.267.camel@pasglop>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chen Yuanquan-B41889 <B41889@freescale.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Date: Thu, 06 Jun 2013 15:44:14 +1000
In-Reply-To: <20130606052508.GA1901@roeck-us.net>
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
	 <51A5CAC1.6030800@freescale.com> <20130531051423.GA15505@roeck-us.net>
	 <1369979047.3928.112.camel@pasglop> <20130601135809.GA6395@roeck-us.net>
	 <1370480404.3766.260.camel@pasglop> <20130606052508.GA1901@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 22:25 -0700, Guenter Roeck wrote:
> 
> 
> Can you point me to some of the breaking code ? I guess it must be in some of
> the pci_dma_dev_setup callbacks, but those I looked at only check devicetree
> data or simply set function pointers, both of which should not be affected by
> the call order.
> 
> How about pcibios_fixup_device, to be called after pcibios_fixup_bus ?

Mostly the pseries ones from a cursory glance. They could be improved to
be agnostic to the call order I suppose or simply done better but heh...

I like using pcibios_add though ... we just need to figure out how to
sort out that ordering if possible.

Cheers,
Ben.


