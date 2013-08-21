Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3HUWWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:22:02 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:47459 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3HUWWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130819044811.GR32147@intel.com>
References: <201308141359.13872.heiko@sntech.de>
	<201308141400.25681.heiko@sntech.de>
	<20130819044811.GR32147@intel.com>
Date: Thu, 22 Aug 2013 00:21:59 +0200
Message-ID: <CACRpkdZL0ErFG2OFd1D-9xQYMY4GJD=zd6sFZenM=HCHD2HszA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Dan Williams <djbw@fb.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 6:48 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Aug 14, 2013 at 02:00:25PM +0200, Heiko Stübner wrote:

>> Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
>> with numerous virtual channels being mapped to a lot less physical ones.
>> The driver therefore borrows a lot from the amba-pl08x driver in this
>> regard. Functionality-wise the driver gains a memcpy ability in addition
>> to the slave_sg one.
>
> If that is the case why cant we have this driver supported from pl08x driver? If
> the delta is only mapping then can that be seprated or both mapping hanlded?
> Maybe you and Linus have already though about that?

I took a look at the register list and couldn't find a way to save code
by trying to shoehorn it into the PL08x, the registers and bit layouts are
totally different. IIRC this driver does not
have LLIs either so it's quite different and would look strange.

Yours,
Linus Walleij
