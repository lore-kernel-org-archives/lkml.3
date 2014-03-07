Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaCGXJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:09:24 -0500
Received: from [65.55.88.14] ([65.55.88.14]:25340 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbaCGXJW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:09:22 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579eh551biz98dIc89bh936eI154dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Fri, 7 Mar 2014 15:08:00 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH RFC v2 04/11] tty: xuartps: Remove bogus comment and
 register write
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
 <1394219614-3197-5-git-send-email-soren.brinkmann@xilinx.com>
 <20140307212816.715e5e19@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140307212816.715e5e19@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <e074f376-9565-422e-abee-fdaa031239a1@TX2EHSMHS043.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 09:28PM +0000, One Thousand Gnomes wrote:
> On Fri,  7 Mar 2014 11:13:27 -0800
> Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  drivers/tty/serial/xilinx_uartps.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
> > index a4bd6242e72d..a39c2d290902 100644
> > --- a/drivers/tty/serial/xilinx_uartps.c
> > +++ b/drivers/tty/serial/xilinx_uartps.c
> > @@ -1082,11 +1082,7 @@ static void xuartps_console_write(struct console *co, const char *s,
> >  
> >  	xuartps_writel(ctrl, XUARTPS_CR_OFFSET);
> >  
> > -	/* restore interrupt state, it seems like there may be a h/w bug
> > -	 * in that the interrupt enable register should not need to be
> > -	 * written based on the data sheet
> > -	 */
> > -	xuartps_writel(~imr, XUARTPS_IDR_OFFSET);
> > +	/* restore interrupt state */
> 
> It would be appropriate for the changelog at least to explain why the
> note about the data sheet differing is going away !

I don't know why anybody ever thought things are broken. IMHO, the
comment does not make any sense. Why would it not be required to write
the enable register when you enable interrupts?
I think someone read the data sheet wrong.

	Sören


