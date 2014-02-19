Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaBSOPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:15:19 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34544 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbaBSOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:15:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140210125113.GZ1757@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
	<1391529538-21685-8-git-send-email-ulf.hansson@linaro.org>
	<20140204191609.GU22609@sirena.org.uk>
	<CAPDyKFqNdw-6R12cUOre8UOTOnB-PpxHD5rPAMCwuS3i--Sesg@mail.gmail.com>
	<20140210125113.GZ1757@sirena.org.uk>
Date: Wed, 19 Feb 2014 15:15:06 +0100
Message-ID: <CAPDyKFqDdoya2+_3b+6SD5r1qXu+o4CVQfXFEHPRA5xr+xg8nQ@mail.gmail.com>
Subject: Re: [PATCH 07/17] spi: pl022: Don't ignore power domain and amba bus
 at system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 February 2014 13:51, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Feb 10, 2014 at 01:33:50PM +0100, Ulf Hansson wrote:
>> On 4 February 2014 20:16, Mark Brown <broonie@kernel.org> wrote:
>
>> > This seems like a fairly hideous thing to be having to open code in an
>> > individual driver, it all looks generic and like something that most if
>
> ...
>
>> > Putting it in a helper would at least mean that it's easier for the
>> > mechanics to be transferred to the core proper later on.
>
>> I agree, a helper function would be nice. I have earlier sent a patch
>> to the PM core, that is similar to the code above, though it was
>> rejected in it's current form. Let me follow up on this again.
>
>> At this point, would a way forward be to still go ahead with this
>> patch and then convert to, when/if, the helper function from the PM
>> core becomes available?
>
> It's definitely *a* way forward, but I'm not convinced it's a good way
> forward.  Since it's something that I'd expect us to be doing in all
> drivers we'd want to replicate it all over the place which is obviously
> not good, or conversely if there are issues that prevented the code
> being added to the PM core then presumably we're just adding problematic
> code to the driver (you've not mentioned what the problems were with
> doing this in the PM core).

I have posted a patch which adds a runtime PM helper function to the
PM core, I am hoping to get some comments soon.
http://marc.info/?l=linux-pm&m=139228211505423&w=2

So I agree, let's put this patch on hold until we sorted out how to
proceed. Though I will rebase and send a v2 of it, just to keep it as
a reference for later use.

Kind regards
Uffe
