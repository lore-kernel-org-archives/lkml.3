Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbbAPK6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:58:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35724 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbAPK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:58:36 -0500
Date: Fri, 16 Jan 2015 10:58:04 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jon Masters <jcm@redhat.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        leif.lindholm@linaro.org
Subject: Re: SPCR table parsing
Message-ID: <20150116105804.GF21809@leverpostej>
References: <54B880B5.6010907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B880B5.6010907@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 03:08:37AM +0000, Jon Masters wrote:
> Hi Folks,
> 
> We're implementing support for SPCR table parsing shortly[0], since it
> will allow to deprecate supplying a "console=" (and eventually, also
> "earlycon=") on 64-bit ARM servers, where it's not always the case that
> we can assume a 16550 at a specific address. SPCR has been provided on
> x86 systems since 2000 but is not (yet) supported by Linux.

For anyone using DT rather than ACPI, the same can be achieved in
mainline with /chosen/stdout-path as of:

7914a7c5651a5161 "of: support passing console options with stdout-path"

Documented in:

2a9d832cc9aae21e "of: Add bindings for chosen node, stdout-path"

e.g.

uart: serial@f00 {
	reg = <0xf00 0x200>;
	compatible = "vendor,some-serial-device";
};

chosen {
	stdout-path = "/serial@f00:115200n8";
};

This will be used for both the console and earlycon. Please make use of
this where possible.

Thanks,
Mark.
