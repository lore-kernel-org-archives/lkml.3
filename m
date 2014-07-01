Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315AbaGAWDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:03:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57883 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965073AbaGAWDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:03:22 -0400
Date: Tue, 1 Jul 2014 23:02:59 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alex Elder <elder@linaro.org>
Cc: gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        david.daney@cavium.com, loic.poulain@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: support high baudrates if possible
Message-ID: <20140701230259.23f2f452@alan.etchedpixels.co.uk>
In-Reply-To: <53AF227C.3000102@linaro.org>
References: <1403889920-1127-1-git-send-email-elder@linaro.org>
	<20140628163608.0c5536a9@alan.etchedpixels.co.uk>
	<53AF227C.3000102@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 15:15:56 -0500
Alex Elder <elder@linaro.org> wrote:

> On 06/28/2014 10:36 AM, One Thousand Gnomes wrote:
> > On Fri, 27 Jun 2014 12:25:20 -0500
> >> +		rate = 16 * max(115200U, (unsigned int)baud);
> >> +
> > 
> > This assumes an arbitarily configurable clock, which is not I think the
> > usual case. 
> 
> If the clock's rate can't change, this will return an error,
> and the recorded rate (p->uartclk) will not be changed.

Which assumes an arbitrarily configurable clock, whereas you want to find
the correct clock and multiplier combination for the baud rate.

Most of these ports are wired to fixed clocks (which is fine) or clocks
with limited numbers of supported frequencies (which is not).

Your patch is an improvement but doesn't really fix the overall problem.
If we have enough devices with variable clocks for it to be useful then
fine - but can we merge it with a big FIXME note so that whoever comes
along wondering why their clock doesn't work or behaves very oddly can
figure it out and fix that case ?

Alan
