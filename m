Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaELV6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:58:24 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40303 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaELV6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140509205218.GA16051@pd.tnic>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
	<1399330337-16748-4-git-send-email-tthayer@altera.com>
	<20140508120524.GF12548@pd.tnic>
	<CAF03EBecxtMr1670ktQKTAZX_kHeZWz1SwuEk373B99BoVjbDw@mail.gmail.com>
	<20140509135259.GC16260@pd.tnic>
	<CAF03EBeKbXr-7+qeARkBRXjystMjs4yEWnmw7q8tgJv9-SPgXA@mail.gmail.com>
	<20140509205218.GA16051@pd.tnic>
Date: Mon, 12 May 2014 16:58:20 -0500
Message-ID: <CAF03EBey1QXo4e0bXQtiMnRYT5OZ_cxD5ShJbmsDYpcxuTx=Fw@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
From: Thor Thayer <tthayer.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 3:52 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, May 09, 2014 at 03:31:53PM -0500, Thor Thayer wrote:
>> Yes, good point. Our hardware can't recover from Double Bit Errors so
>> I'll go back to the panic() in that path. I like the flexibility of
>> the command line parameter though...
>
> Like to panic by default when the machine is booted normally but to be
> able to turn off the panicking with a module parameter?
>
> If so, then you could probably implement a trivial setter called
>
> edac_mc_set_panic_on_ue() in a separate patch.
>
> Then, you call it at the end of altr_sdram_probe().
>
> If you want to turn it off again, you do
>
> echo "0" > /sys/module/edac_core/parameters/edac_mc_panic_on_ue
>
> Something like that...
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --

Hi Boris. Yes. this would be a nice solution. I'll use the panic for
now in my next revision of the patch - we know a DBE is bad news.
Thanks!
