Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaGHLmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:42:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45625 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaGHLmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:42:33 -0400
Date: Tue, 8 Jul 2014 13:42:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Pavel Machek <pavel@denx.de>
Cc: tthayer@altera.com, robherring2@gmail.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        tthayer.linux@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCHv7 3/3] edac: altera: Add EDAC support for Altera SoC
 SDRAM Controller.
Message-ID: <20140708114227.GB27659@pd.tnic>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
 <1403730927-16163-4-git-send-email-tthayer@altera.com>
 <20140708113109.GC8100@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140708113109.GC8100@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:31:09PM +0200, Pavel Machek wrote:
> > +	read_reg = readl(mc_vbase + DRAMADDRW);
> > +
> > +	width = readl(mc_vbase + DRAMIFWIDTH);
> > +
> > +	col = (read_reg & DRAMADDRW_COLBIT_MASK) >>
> > +		DRAMADDRW_COLBIT_LSB;
> > +	row = (read_reg & DRAMADDRW_ROWBIT_MASK) >>
> > +		DRAMADDRW_ROWBIT_LSB;
> > +	bank = (read_reg & DRAMADDRW_BANKBIT_MASK) >>
> > +		DRAMADDRW_BANKBIT_LSB;
> > +	cs = (read_reg & DRAMADDRW_CSBIT_MASK) >>
> > +		DRAMADDRW_CSBIT_LSB;
> 
> As I said, all the defines only make this harder to read. The code is
> pretty obvious if you put numbers in here...

Since when it is a good coding practice to put naked numbers instead of
descriptive macro names??!

Now, I can understand that the macro names could be made more
descriptive so that you can understand what they mean, but naked
numbers?! You must be joking although 1st of April is long gone.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
