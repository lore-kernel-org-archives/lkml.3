Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbbA0Oly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:41:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:27202 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbbA0Olw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:41:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="668389015"
Date: Tue, 27 Jan 2015 16:41:27 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: i2c-hid: Add support for GPIO interrupts
Message-ID: <20150127144127.GT1451@lahna.fi.intel.com>
References: <20150126151637.GH1451@lahna.fi.intel.com>
 <20150126160044.GK23313@leverpostej>
 <20150126161356.GJ1451@lahna.fi.intel.com>
 <20150126163929.GL23313@leverpostej>
 <20150127101610.GK1451@lahna.fi.intel.com>
 <20150127103925.GB17721@leverpostej>
 <20150127105931.GN1451@lahna.fi.intel.com>
 <20150127111458.GD17721@leverpostej>
 <20150127113041.GP1451@lahna.fi.intel.com>
 <20150127143334.GF17721@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127143334.GF17721@leverpostej>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 02:33:34PM +0000, Mark Rutland wrote:
> Ok, that allays my fear w.r.t. ordering of the resources.
> 
> As I see it, the fact that we convert GpioInt entries to GPIOs rather
> than irqs when parsing _CRS is the issue here, and to me it makes no
> sense that we do so. Were we to treat them as interrupts, the binding is
> fine as-is, and we'd do the same thing in DT and ACPI.
> 
> The reason GpioInt is separate from GpioIo is that a GpioInt _is_ an
> interrupt (which happens to be backed by a GPIO), and is not something
> that necessarily makes sense as a GPIO.

I would rather say that GpioInt *is* a GPIO. That can then used as an
interrupt but it should not prevent you from using it as GPIO instead.
For example if you just want to poll that something is 0 or 1. That
should be possible as well and nothing say that you cannot do that for
GpioInt().

> So why do we currently ignore the GpioInt/GpioIo distinction and treat
> GpioInts as GPIOs rather than interrupts?

See above.
