Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaGHMEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:04:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53177 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaGHMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:04:34 -0400
Date: Tue, 8 Jul 2014 14:04:32 +0200
From: Pavel Machek <pavel@denx.de>
To: Borislav Petkov <bp@alien8.de>
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
Message-ID: <20140708120432.GB8628@amd.pavel.ucw.cz>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
 <1403730927-16163-4-git-send-email-tthayer@altera.com>
 <20140708113109.GC8100@amd.pavel.ucw.cz>
 <20140708114227.GB27659@pd.tnic>
 <20140708115205.GA8628@amd.pavel.ucw.cz>
 <20140708115458.GC27659@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708115458.GC27659@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-08 13:54:58, Borislav Petkov wrote:
> On Tue, Jul 08, 2014 at 01:52:05PM +0200, Pavel Machek wrote:
> > I'm not joking. Try to understand and verify the code above. You
> > can't. The "descriptive macro names" are useless; all the code does is
> > split register in pieces. With the numbers it would be  very obvious.
> 
> No, you need to fix the names not switch to naked numbers.

Hiding numbers that are used just once into defines to put them out of
sight does not really help readability.

Compare:

+#define DRAMADDRW_COLBIT_MASK	0x001F
+#define DRAMADDRW_COLBIT_LSB	0
+#define DRAMADDRW_ROWBIT_MASK	0x02E0
+#define DRAMADDRW_ROWBIT_LSB	5
+#define DRAMADDRW_BANKBIT_MASK	0x1C00
+#define DRAMADDRW_BANKBIT_LSB	10
+#define DRAMADDRW_CSBIT_MASK	0xE000
+#define DRAMADDRW_CSBIT_LSB	13

(Insert few screens of code so that you have to scroll or split
window).

What information do the define names have? None, I already know how
hardware registers work.

+	col = (read_reg & DRAMADDRW_COLBIT_MASK) >>
+	     DRAMADDRW_COLBIT_LSB;
+	row = (read_reg & DRAMADDRW_ROWBIT_MASK) >>
+	     	 DRAMADDRW_ROWBIT_LSB;
+	bank = (read_reg & DRAMADDRW_BANKBIT_MASK) >>
+		      DRAMADDRW_BANKBIT_LSB;
+	cs = (read_reg & DRAMADDRW_CSBIT_MASK) >>
+		      	 DRAMADDRW_CSBIT_LSB;

Instead, we could have:

	 col = read_reg & 0x001F;
	 row = (read_reg & 0x02E0) >> 5;
	 bank = (read_reg & 0x1C00) >> 10;
	 cs = (read_reg & 0xE000) >> 13;

All information is preserved, code is shorter and easier to understand.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
