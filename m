Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaBRThy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:37:54 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:44878 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaBRThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:37:51 -0500
X-Auth-Info: sqsuJ+tM76M+wFkdfh4z+/Gbtmmfbf7e9nGfXeVQqLM=
Date: Tue, 18 Feb 2014 20:37:47 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Mark Brown <broonie@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] spi: core: Validate lenght of the transfers in message
Message-ID: <20140218193747.GE4524@book.gsilab.sittig.org>
References: <1392444566-23605-1-git-send-email-iivanov@mm-sol.com>
 <20140216142512.GR4524@book.gsilab.sittig.org>
 <20140218000938.GE2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218000938.GE2669@sirena.org.uk>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:09 +0900, Mark Brown wrote:
> 
> On Sun, Feb 16, 2014 at 03:25:12PM +0100, Gerhard Sittig wrote:
> > On Sat, Feb 15, 2014 at 08:09 +0200, Ivan T. Ivanov wrote:
> 
> > - the total length of the SPI transfer cannot be empty (which I'd
> >   consider an optimization, not a violation, and may need a
> >   separate discussion)
> 
> We probably want to allow that for people doing fun stuff with cs_change
> though I'm not convinced anything doing that is actually a good idea.
> 
> > - the total length of the SPI transfer must be such that each
> >   "word" must be provided within a full 1/2/4 byte entity, with
> >   padding bits if the bits-per-word is "odd"
> 
> > Is this a misunderstanding on my side?  A terminology thing?  To
> > me, the "SPI transfer" is the total payload and may have any
> > arbitrary length.  What you check for is a constraint on the
> > transfer's length derived from or based on the "word length"
> > ('word' in SPI context).
> 
> > So the code may be appropriate, yet the description may need an
> > update, to not have the next person ask the same questions again.
> 
> It seems fairly clear to me - if we're transferring 16 bit words we need
> the transfer to me a multiple of 16 bits and so on?  The requirement for
> padding is unclear I have to say.

I meant "padding" in the sense that e.g. 12bit bits-per-word
require data to be provided or consumed in 16bit quantities (2
full bytes), 20bit bits-per-word require 4 bytes per SPI word.
Why not 3 bytes?  I'd guess this is due to FIFO port width.

At least this is how I read the check which this patch
implements.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
