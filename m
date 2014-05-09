Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaEIUwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:52:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41404 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbaEIUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:52:22 -0400
Date: Fri, 9 May 2014 22:52:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thor Thayer <tthayer.linux@gmail.com>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
Message-ID: <20140509205218.GA16051@pd.tnic>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
 <1399330337-16748-4-git-send-email-tthayer@altera.com>
 <20140508120524.GF12548@pd.tnic>
 <CAF03EBecxtMr1670ktQKTAZX_kHeZWz1SwuEk373B99BoVjbDw@mail.gmail.com>
 <20140509135259.GC16260@pd.tnic>
 <CAF03EBeKbXr-7+qeARkBRXjystMjs4yEWnmw7q8tgJv9-SPgXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF03EBeKbXr-7+qeARkBRXjystMjs4yEWnmw7q8tgJv9-SPgXA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:31:53PM -0500, Thor Thayer wrote:
> Yes, good point. Our hardware can't recover from Double Bit Errors so
> I'll go back to the panic() in that path. I like the flexibility of
> the command line parameter though...

Like to panic by default when the machine is booted normally but to be
able to turn off the panicking with a module parameter?

If so, then you could probably implement a trivial setter called

edac_mc_set_panic_on_ue() in a separate patch.

Then, you call it at the end of altr_sdram_probe().

If you want to turn it off again, you do

echo "0" > /sys/module/edac_core/parameters/edac_mc_panic_on_ue

Something like that...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
