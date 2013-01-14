Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3ANCfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:35:08 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33401 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3ANCfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:35:05 -0500
Date: Mon, 14 Jan 2013 02:34:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [RFC-v2 1/7] capebus: Core capebus support
Message-ID: <20130114023439.GB4928@sirena.org.uk>
References: <1351783952-11804-1-git-send-email-panto@antoniou-consulting.com>
 <1351783952-11804-2-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351783952-11804-2-git-send-email-panto@antoniou-consulting.com>
X-Cookie: Smile!  You're on Candid Camera.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 05:32:26PM +0200, Pantelis Antoniou wrote:
> Introducing capebus; a bus that allows small boards (capes) to connect
> to a complex SoC using simple expansion connectors.
> 
> Up to now to support these kind of boards, one had to hack the board files,
> and do all sort of gymnastics to handle all the different cases of
> conflict resolution.

Would it be possible to split out the DT support from the underlying
bus?  Looking at the code it seems like we're relying on DT for a lot of
the functionality when it comes to mapping devices into the system but
that doesn't really meet what I'm looking for.  One of the use cases I
have is supporting modules which can be used with multiple systems so I
really want to be able to just define the modules once and then have a
layer in the subsystem which remaps the connections onto the actual
hardware.
