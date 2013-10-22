Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3JVC5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 22:57:14 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:36264 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904Ab3JVC5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 22:57:12 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2013 22:57:12 EDT
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Mark Brown <broonie@kernel.org>, "Lin, JM" <JM.Lin@atmel.com>
Subject: RE: [BUG] spi/spi-atmel: DMA rx buffer corruption with
 SPI_IOC_MESSAGE
Thread-Topic: [BUG] spi/spi-atmel: DMA rx buffer corruption with
 SPI_IOC_MESSAGE
Thread-Index: AQHOxBNtqj14WIxJgkiXUBKLYopIXpn4QhGAgAacvbD//4FKgIABt+qQ
Date: Tue, 22 Oct 2013 02:51:52 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172E9D2EB@penmbx01>
References: <CACQ1gAhNFTdG_2OCTnsOCaBozHnGb9EwAGHT5+f=cARRpC_WBg@mail.gmail.com>
 <CACQ1gAjT30VLg5u5s6skRw0svMLavM2rZkG879VzmphtoKb=Vg@mail.gmail.com>
 <B256D81BAE5131468A838E5D7A24364172E9CFB1@penmbx01>
 <CACQ1gAh-ZmL27q2w-0Aj4Lw6p6Y87cEJL7k_Ai9taDmsH_-qjg@mail.gmail.com>
In-Reply-To: <CACQ1gAh-ZmL27q2w-0Aj4Lw6p6Y87cEJL7k_Ai9taDmsH_-qjg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {B9BCB04F-50D1-4A5C-9C2B-5058BDAA0151}
x-cr-hashedpuzzle: B6ij EFcB Ho/s JdRG KVer LR2a ONIJ Okdk OudU S/Cn VquM
 X3y/ YCz3 dWDQ fCYh
 rV1l;4;YgByAG8AbwBuAGkAZQBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AcwBwAGkAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAaQBjAGgAYQByAGQALgBnAGUAbgBvAHUAZABAAGcAbQBhAGkAbAAuAGMAbwBtAA==;Sosha1_v1;7;{B9BCB04F-50D1-4A5C-9C2B-5058BDAA0151};dwBlAG4AeQBvAHUALgB5AGEAbgBnAEAAYQB0AG0AZQBsAC4AYwBvAG0A;Tue,
 22 Oct 2013 02:51:42
 GMT;UgBFADoAIABbAEIAVQBHAF0AIABzAHAAaQAvAHMAcABpAC0AYQB0AG0AZQBsADoAIABEAE0AQQAgAHIAeAAgAGIAdQBmAGYAZQByACAAYwBvAHIAcgB1AHAAdABpAG8AbgAgAHcAaQB0AGgAIABTAFAASQBfAEkATwBDAF8ATQBFAFMAUwBBAEcARQA=
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9M2vM8Z003496



> -----Original Message-----
> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> Sent: 2013Âπ¥10Êúà21Êó• 16:26
> To: Yang, Wenyou
> Cc: linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre, Nicolas;
> Mark Brown
> Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with
> SPI_IOC_MESSAGE
> 
> 2013/10/21 Yang, Wenyou <Wenyou.Yang@atmel.com>:
> > Hi Richard,
> >
> >> -----Original Message-----
> >> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> >> Sent: 2013Âπ¥10Êúà17Êó• 19:01
> >> To: Yang, Wenyou
> >> Cc: linux-spi@vger.kernel.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas;
> >> Mark Brown
> >> Subject: Re: [BUG] spi/spi-atmel: DMA rx buffer corruption with
> >> SPI_IOC_MESSAGE
> >>
> >> 2013/10/8 Richard Genoud <richard.genoud@gmail.com>:
> >> > Hi all,
> >> >
> >> > I finally found the bug I saw months ago, before "[PATCH v8 3/8]
> >> > spi/spi-atmel: add dmaengine support" was merged.
> >> >
> >> > Here it is:
> >> >
> >> > When the ioctl SPI_IOC_MESSAGE is used with small and big buffers,
> >> > the big RX buffer is corrupted with bytes from the big TX buffer.
> >> > (Small means size < DMA_MIN_BYTES, Big means size >
> >> DMA_MIN_BYTES)
> >> >
> >> > I'm attaching the test software that I used ( ./spi_test /dev/spidevx.x )
> >> >
> >> > It fills 3 TX buffers with 0xAA pattern: a small, a big and a small again.
> >> > It reads in return 3 RX buffers.
> >> > The MISO pin has to be on 3.3v.
> >> >
> >> > It checks if the received buffers are filled with 0xFF (they should
> >> > be, as MISO is high).
> >> > And I've got a lot of buffers filled partially with 0xAA bytes.
> >> >
> >> > BUT, if you apply this patch:
> >> > ---8<----
> >> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> >> > index 83cf609..cde42a4 100644
> >> > --- a/drivers/spi/spi-atmel.c
> >> > +++ b/drivers/spi/spi-atmel.c
> >> > @@ -187,7 +187,7 @@
> >> >  /* use PIO for small transfers, avoiding DMA setup/teardown
> overhead
> >> and
> >> >   * cache operations; better heuristics consider wordsize and
> bitrate.
> >> >   */
> >> > -#define DMA_MIN_BYTES  16
> >> > +#define DMA_MIN_BYTES  0
> >> >
> >> >  struct atmel_spi_dma {
> >> >         struct dma_chan                 *chan_rx;
> >> > ---8<----
> >> > There's no error any more.
> >> > So there's something wrong happening when switching from/to pio
> >> > transfer to/from DMA.
> >> >
> >> > We didn't saw that at the time of the merge because we did the test
> >> > with a loop on MISO/MOSI,
> >> > so the RX buffer was corrupted with identical bytes.
> >> >
> >> > Best regards,
> >> > Richard.
> >>
> >> Hi Wenyou,
> >>
> >> Did you have the opportunity to give it a test ?
> >>
> >> Thread: https://lkml.org/lkml/2013/10/8/329
> > I tried to reproduce it with this thread, but I didn't
> > Which slave device did you use?
> 
> Hi Wenyou,
> 
> I'm not using any slave device, I'm just setting the MISO pin to 3.3V,
> then I execute the C code ( https://lkml.org/lkml/2013/10/8/329 )
> So, we should only receive 0xFF in the buffer.
> But i'm getting :
> aa aa aa aa aa aa aa aa aa aa aa aa aa aa ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff
> aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> aa aa aa aa aa aa aa aa aa aa aa aa aa aa ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff ff ff
> 
Hi, Richard,

The bug is reproduced.
Tested on at91sam9g25ek, Linux-3.6.9.

> Richard.

Best Regards,
Wenyou Yang
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
