Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaCRMN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:13:56 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42170
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbaCRMNx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:13:53 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h262fh906i1155h)
From: Harini Katakam <harini.katakam@xilinx.com>
To: Mark Brown <broonie@kernel.org>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Topic: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Index: AQHPQdlDwreFYNSC5UqDMedDfaXPCprlA1GAgAGtBQKAABI78A==
Date: Tue, 18 Mar 2014 12:13:45 +0000
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <20140317173017.GW11706@sirena.org.uk>
 <255edf4f-05a8-4d9a-b32d-1a4a8ddaffb5@CH1EHSMHS004.ehs.local>
 <20140318110401.GH11706@sirena.org.uk>
In-Reply-To: <20140318110401.GH11706@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.19.72]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <d7cf691a-c9cb-4a8a-bf5c-eae952a5d729@VA3EHSMHS045.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Tuesday, March 18, 2014 4:34 PM
> To: Harini Katakam
> Cc: robh+dt@kernel.org; pawel.moll@arm.com; mark.rutland@arm.com;
> ijc+devicetree@hellion.org.uk; galak@codeaurora.org; rob@landley.net;
> grant.likely@linaro.org; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> spi@vger.kernel.org; Michal Simek
> Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
>
> On Tue, Mar 18, 2014 at 05:16:26AM +0000, Harini Katakam wrote:
>
> Please fix your mailer to word wrap within paragraphs, this will make
> your mail much more legible.
>
> > > > +       if (bits_per_word != 8) {
> > > > +               dev_err(&spi->dev, "%s, unsupported bits per word %x\n",
> > > > +                       __func__, spi->bits_per_word);
> > > > +               return -EINVAL;
> > > > +       }
>
> > > The core will check this for you.
>
> > I dint find that the core does this.
>
> bpw_mask.
>

OK. Will set master->bits_per_word_mask.

> > > It's not clear to me why this has been split into a separate function and
> the
> > > function will write to the hardware which you're not allowed to do in
> > > setup() if it might affect an ongoing transfer.
>
> > Are you saying  that there's a chance cdns_spi_setup() will be called
> > when there's an ongoing transfer?  In that case I have to remove the
> > cdns_setup_transfer() call from here but then there's nothing left to
> > do in setup.
>
> yes.
>

I'm going to remove the bits_per_word check anyway.
But the clock configuration still needs to be done.
Where should it be done spi_setup() or transfer?

Can you please comment on this?

"The function was split into two because cdns_spi_setup_transfer() is called internally by transfer_one_message() everytime.
Is it always possible that the spi_transfer paramters will remain the same?
In that case this call is probably not necessary in transfer_one_message."

> > > I see from further up the file that there are error interrupt states which
> > > might be flagged but these are just being ignored.
>
> > I'm not sure I understand what you are referring to -
> > The only interrupts enabled (See CNDS_IXR_DEFAULT_MASK) are TXOW
> and MODF.
>
> The code had:
>
> > +#define CDNS_SPI_IXR_TXOW_MASK 0x00000004 /* SPI TX FIFO
> Overwater */
> > +#define CDNS_SPI_IXR_MODF_MASK 0x00000002 /* SPI Mode Fault */
> > +#define CDNS_SPI_IXR_RXNEMTY_MASK 0x00000010 /* SPI RX FIFO Not
> Empty */
>
> > +#define CDNS_SPI_IXR_TXFULL_MASK       0x00000008 /* SPI TX Full */
>
> and defined:
>
> > +#define CDNS_SPI_IXR_ALL_MASK  0x0000007F /* SPI all interrupts */
>
> > > > +       return IRQ_HANDLED;
>
> > > This should only be returned if an interrupt was actually handled - if the
> line
> > > is shared in some system this will break.
>
> > In this case both possible interrupt conditions are handled.
>
> Are you sure that's the case, and even if you are that's still not
> handling the case where the device isn't flagging an interrupt at all.
>

The IXR_ALL mask is only used to disable all the interrupts in the beginning.
These two are the only interrupts enabled.
And RXNEMPTY status is just polled. That interrupt is not enabled either

Regards,
Harini


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


