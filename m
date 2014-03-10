Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaCJOlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:41:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:56428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaCJOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:41:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Peter Pearse <peter.pearse@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
Date: Mon, 10 Mar 2014 15:40:33 +0100
Message-ID: <4828160.ZrKNlE4ee8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394461668.2270.47.camel@shinybook.infradead.org>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <5345792.VhzckVI5HA@wuerfel> <1394461668.2270.47.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ghahdsLTVFpQSt4luuCX+UktUzPZUXEcsPkoRB5+1q5
 t0q/XywHaFKwIIQOhg7GymjRucU1vy2cfBGZRVDjrhvfi8RgQq
 igYIafWQqwfVqClyDvk7h+ae663hAa1e/YvKzMGajlWllRogiG
 40KyFwsWJZemCtVKn8rndoSN0ZqGGH/4fPXfsxxosTKT3f15Y1
 p/Z+2u0xcpcCDguCl9jGiaIXwx9LEK8cE9A2mWPCoUVJwUHDZA
 DU8qGzFO4Men/Pnl7QHzgd8UGhI0Y1F8pazsrj1/dm3nVKT1+c
 RzPrteQK4ZDa3pNUs4X2pg6lQWOAPvtLbQC6sac3IAHnqfL6zG
 asCLlpZcfLzc8ALOpGZI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 07:27:48 David Woodhouse wrote:
> 
> > There are multiple reasons why
> > we have to pass the dmaengine device to the dma-mapping API at the moment
> > rather than the slave device, but in essence it comes down to the engine
> > being the one that is the master on its parent bus. A trivial example
> > where it goes wrong would be the slave living on a 32-bit noncoherent bus
> > and the master living on a 64-bit coherent bus.
> 
> That's true in the general case, certainly. But in this case we're
> basically just talking about different functions of a multifunction
> device. 

Ah, I thought you were talking about a generic SoC with lots of units
on it.

> It may turn out that we need the *flexibility* to specify which
> device shall be used for DMA mappings for a given channel, even if in
> *most* cases it ends up being the DMA controller itself.

Yes, that would probably work with a helper function that can
pull the right device structure out of the ACPI description (or
whatever the DMA engine needs) given the dma channel pointer, or
fall back to the dma engine.

	Arnd
