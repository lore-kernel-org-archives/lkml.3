Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3C1JuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:50:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46859 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3C1JuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:50:22 -0400
Date: Thu, 28 Mar 2013 09:50:12 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Nishanth Menon <nm@ti.com>, linux-kernel@vger.kernel.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130328095011.GS30923@n2100.arm.linux.org.uk>
References: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg> <20130306175120.GP11806@atomide.com> <201303062013.16302@pali> <201303241526.59275@pali> <20130327205606.GN10155@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130327205606.GN10155@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 01:56:07PM -0700, Tony Lindgren wrote:
> * Pali Rohár <pali.rohar@gmail.com> [130324 07:31]:
> > it is possible to upstream errata 430973 workaround for RX-51?
> 
> I think we should make the SMC handling a generic function for ARM.
> 
> AFAIK just the SMC call numbering is different for various
> implementations. So the handler and passing of the parameters
> seems like it should be generic.

SMC calls vary greatly in how they are handled.  The only thing that's
generic is issuing the SMC call.  All the setup and what arguments are
required are completely different from SoC to SoC.

For example, some SoCs require arguments passed via memory.  Others like
OMAP its via registers.
