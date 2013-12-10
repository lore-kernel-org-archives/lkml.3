Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3LJWsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:48:21 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33502 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LJWsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:48:18 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Tim Kryger <tim.kryger@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Date: Tue, 10 Dec 2013 22:48:06 +0000
Message-ID: <5829576.XRqmsfpHkX@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.10.5 (Linux/3.12.3+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131210121154.GA16238@localhost>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org> <CAAYSxhraDF6T9URw0CpEig2VpnuTBNdZYL9uuw6vdPn0=X4zGA@mail.gmail.com> <20131210121154.GA16238@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9126169.0cbx9Cncuf"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart9126169.0cbx9Cncuf
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 10 December 2013 09:11:55 Ezequiel Garcia wrote:
> Hi Tim, James:
> 
> On Mon, Dec 09, 2013 at 04:42:23PM -0800, Tim Kryger wrote:
> > On Fri, Dec 6, 2013 at 4:59 PM, James Hogan <james.hogan@imgtec.com> 
wrote:
> [..]
> 
> > diff --git a/drivers/tty/serial/8250/8250_dw.c
> > b/drivers/tty/serial/8250/8250_dw.c
> > index 4658e3e..5f096c7 100644
> > --- a/drivers/tty/serial/8250/8250_dw.c
> > +++ b/drivers/tty/serial/8250/8250_dw.c
> > @@ -96,7 +96,8 @@ static void dw8250_serial_out(struct uart_port *p,
> > int offset, int value)
> > 
> >         if (offset == UART_LCR) {
> >         
> >                 int tries = 1000;
> >                 while (tries--) {
> > 
> > -                       if (value == p->serial_in(p, UART_LCR))
> > +                       unsigned int lcr = p->serial_in(p, UART_LCR);
> > +                       if ((value & ~UART_LCR_SPAR) == (lcr &
> > ~UART_LCR_SPAR))> 
> >                                 return;
> >                         
> >                         dw8250_force_idle(p);
> >                         writeb(value, p->membase + (UART_LCR <<
> >                         p->regshift));
> > 
> > @@ -132,7 +133,8 @@ static void dw8250_serial_out32(struct uart_port
> > *p, int offset, int value)
> > 
> >         if (offset == UART_LCR) {
> >         
> >                 int tries = 1000;
> >                 while (tries--) {
> > 
> > -                       if (value == p->serial_in(p, UART_LCR))
> > +                       unsigned int lcr = p->serial_in(p, UART_LCR);
> > +                       if ((value & ~UART_LCR_SPAR) == (lcr &
> > ~UART_LCR_SPAR))> 
> >                                 return;
> >                         
> >                         dw8250_force_idle(p);
> >                         writel(value, p->membase + (UART_LCR <<
> >                         p->regshift));
> > 
> > Would you mind posting this for proper review so we can get the fix in?
> 
> Applying this change fixes all the problems I reported (just did a quick
> test on the board I have currently on my desk).
> 
> Nice work!

Thanks for testing it.

I've posted Tim's version for proper review with both your tested-by.

Cheers
James
--nextPart9126169.0cbx9Cncuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJSp5ouAAoJEKHZs+irPybfaR8P/R6SrFsvocrdOCjNVdkWXuPF
NG27O5MVE1WvjvTuWmsd89NxZhBRquK31gi9qSr/uPzy9v5azu4FBgWJUqlIvpQN
JpYwcWHmkUF15fFyXK7AXu6VQ4DgVEnc33xPRS6Ym4U0/BTX91eNvrqzyblQ9OhA
6KvRp8rC+dqRJw6+xIX18PgH8/mu2SLOVD7W3XbOo43T5t2B5x1DoTgmgQloafTM
w3R+0wfN12NJSsw/wjTonLa6DYQQl96MfbvAF98sMai20Rdtt5dt4irtDu9TMjZP
GhKbRVfJxgWjq5R5wo2oa1r/YypymPUW3TJEa/kWcNmSq9DJlRWekBbWgY8+8Fjf
H/LXdVzlM6ArpcirQHV2g1EaMWGo4lwAkwSLx0GcvH36oQlcUUSxsGtmp40wNhF1
8/8WO+pZIYNdE2JorZyEBnGoygTJ/SF1Xd8YgY0o5KFAXkLXCSMCPyPFgroD+zWA
X4jr2qu5dw2Gmni5vPJkrVPmYOYGSkxk5fH2iux35iTiLpDHk+TEcZN2jd7R+ZDP
EbGTkdzKlqsqUsLsvznhecHrseTjs7A0R2FMH60mNUIVKkoZ27KD+zcLDOvSqDNe
xelMde1EX98cCYUK1q+PiYUcgyF/Am4hkmU610tSfZUibIIovcRHEGpdtNvWAuOt
idqLTtgprnKlf50UDpA/
=QdKq
-----END PGP SIGNATURE-----

--nextPart9126169.0cbx9Cncuf--

