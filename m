Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3GaM6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:58:16 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:28573 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3GaM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:58:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,787,1367971200"; 
   d="scan'208";a="7319649"
Message-ID: <1375275491.7382.39.camel@kazak.uk.xensource.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Olof Johansson <olof@lixom.net>, Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Domenico Andreoli" <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Wed, 31 Jul 2013 13:58:11 +0100
In-Reply-To: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 18:57 +0100, Mark Rutland wrote:
> > A possible way to handle this is to have exactly that: A group of
> > people that essentially constitute the "standards committee" that meet
> > on a regular basis to review and approve new bindings. They should be
> > people not just doing ARM Linux work, but other stakeholders in these
> > bindings too. One of the things they should probably do is sift
> > through our current in-kernel bindings and select those who seem ready
> > to be locked in, review/discuss/decide upon that and once the decision
> > is made, that specific binding does become part of the static,
> > never-ever-change ABI of firmware-to-kernel interfaces.   That might
> > also be the time that the binding is moved from the kernel to a
> > separate repo, but that's a technicality that we'll let the DT
> > maintainers decide among themselves, IMHO.
> 
> We're going to need input from other OSs too, or the bindings will
> remain Linux-specific regardless of how far away the bindings and dts
> repo(s) is/are.

FWIW my primary interest in stable DT ABIs is because Xen would like to
consume the same device trees on boot, as well as be able to do other
clever things with DT at runtime. Specifically:
      * Take the host device tree passed to Xen at boot, filter out the
        stuff which Xen uses for itself (which is for the most part core
        architectural stuff) and pass the remainder to the dom0 Linux
        kernel (or perhaps in the future another kernel) to drive the
        remainder of the hardware (mostly the SoC specific stuff, but
        some architectural and some Xen defined stuff too)
      * Generate a suitable DT for a guest domain on the fly depending
        on the guest configuration.

Obviously both of those need a stable ABI for us to understand,
manipulate and generate.

Ian.

