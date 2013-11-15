Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3KOPIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:08:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54947 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147Ab3KOPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:08:14 -0500
Date: Fri, 15 Nov 2013 15:07:45 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Bonn <jonas@southpole.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
Message-ID: <20131115150745.GB24831@e106331-lin.cambridge.arm.com>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
 <5285EE5A.1070202@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5285EE5A.1070202@southpole.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:50:18AM +0000, Jonas Bonn wrote:
[...]

> > +	gpio0: gpio@91000000 {
> > +		compatible = "opencores,jbtrivial";
> 
> There's no project called 'jbtrivial' at OpenCores.  Should this be 
> "linux,jbtrivial" to indicate that this refers to a Linux driver?

I would prefer not. Having driver names in bindings is an antipattern;
drivers should be free to change independently of the hardware or
bindings, and we should be able to create new drivers that handle
existing bindings.

Either a new compatible string should be allcoated, or one of the
generic bindings should be used. While we do have drivers for the
generic cases, the *-generic bindings are treated as a specification
that hardware can meet, and are not intended to change. They are also
there fore independent of Linux.

Thanks,
Mark.
