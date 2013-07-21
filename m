Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3GUUpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 16:45:19 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48220 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab3GUUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 16:45:17 -0400
Message-ID: <51EC4859.5000007@gmail.com>
Date: Sun, 21 Jul 2013 15:45:13 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Huang Shijie <b32955@freescale.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: match the compatible in the order set by the dts
 file
References: <1373013818-11365-1-git-send-email-b32955@freescale.com> <20130709070541.GQ516@pengutronix.de> <51DBBFDA.70302@freescale.com> <20130709075124.GR516@pengutronix.de> <51DBC58D.90002@freescale.com> <20130720054439.308B33E13F0@localhost>
In-Reply-To: <20130720054439.308B33E13F0@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 12:44 AM, Grant Likely <grant.likely@linaro.org>
wrote:
> On Tue, 9 Jul 2013 16:10:53 +0800, Huang Shijie <b32955@freescale.com> wrote:
>> 于 2013年07月09日 15:51, Sascha Hauer 写道:
>> > On Tue, Jul 09, 2013 at 03:46:34PM +0800, Huang Shijie wrote:
>> >> 于 2013年07月09日 15:05, Sascha Hauer 写道:
>> >>> Why don't you set the matching order in the driver the way you want it
>> >>> to be, i.e.:
>> >>>
>> >>>   { .compatible = "fsl,imx6q-uart", ... },
>> >>>   { .compatible = "fsl,imx21-uart", ... },
>> >>>   { .compatible = "fsl,imx1-uart", ... },
>> >>>
>> >> yes. i can set it like this.
>> >>
>> >> but this method looks like a ugly workaround.
>> > If a driver has different ways of supporting a single device, then
>> > putting the preferred or most feature rich on top doesn't look very ugly
>> > to me.
>> this method makes it much _coupled_ between the driver and the dts file.
>>
>> IMHO, it's an unnecessary _burden_ to the driver programmer:
>>     he should puts the most feature compatible on the top.
>>
>> it's much graceful if we let the driver programmer be transparent about
>> this.
>
> Absolutely true. Applied, thanks.

We can debate whether the driver order matters or not, but either way
I'm not sure this patch does the right thing. It doesn't really look
correct to me, but I haven't dug into it.

We've already tried to fix matching and reverted the fix once before
(commit below). So this patch needs careful review and thought about
cases where the name and/or type is used to match.

commit bc51b0c22cebf5c311a6f1895fcca9f78efd0478
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jul 10 12:49:32 2012 -0700

    Revert "of: match by compatible property first"

    This reverts commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6.

    Meelis Roos reports a regression since 3.5-rc5 that stops Sun Fire V100
    and Sun Netra X1 sparc64 machines from booting, hanging after enabling
    serial console.  He bisected it to commit 107a84e61cdd.

    Rob Herring explains:
     "The problem is match combinations of compatible plus name and/or type
      fail to match correctly.  I have a fix for this, but given how late it
      is for 3.5 I think it is best to revert this for now.  There could be
      other cases that rely on the current although wrong behavior.  I will
      post an updated version for 3.6."

    Bisected-and-reported-by: Meelis Roos <mroos@linux.ee>
    Requested-by: Rob Herring <rob.herring@calxeda.com>
    Cc: Thierry Reding <thierry.reding@avionic-design.de>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Rob
