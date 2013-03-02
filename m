Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3CBIyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 03:54:25 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:46556 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3CBIyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 03:54:24 -0500
Date: Sat, 2 Mar 2013 16:54:57 +0800
From: Wang YanQing <udknight@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: gregkh@linuxfoundation.org, swarren@wwwdotorg.org, jslaby@suse.cz,
        alan@linux.intel.com, arnd@arndb.de, damm@opensource.se,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]serial: 8250: Fix detect XScale port wrong
Message-ID: <20130302085457.GA3669@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	gregkh@linuxfoundation.org, swarren@wwwdotorg.org, jslaby@suse.cz,
	alan@linux.intel.com, arnd@arndb.de, damm@opensource.se,
	linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130301055610.GA31770@udknight>
 <5130FEBC.7030806@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5130FEBC.7030806@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 02:17:16PM -0500, Paul Gortmaker wrote:
> On 13-03-01 12:56 AM, Wang YanQing wrote:
> > Some UARTs add enhanced functions with unused bit in
> > 16550 standard, like UART_IER_UUE bit, it cause XScale
> 
> Which xscale platform?  It would be nice to know the specifics.
The "XScale" mean the XScale port detect code in autoconfig_16550a,
I meet the problem in a normal pc motherboard, I should rephrase
the subject use "Fix detect 16550A ports as XScale ports wrong"
> 
> > detect wrong. Now detect UART_IER_UUE and UART_IER_RTOIE
> > to reduce the annoying wrong result which cause UARTs don't
> > work.
> 
> You should ideally identify the original commit which caused
> the regression.  Assuming you have fully understood the problem
> you should be able to do this with "git blame" and not need to
> do the full bisect.
>
No it is not a regression, it is caused just like you say
there are many 8250/16550 variations, and I meet one, that is it.

> 
> > 
> > Serial controller: Device 4348:3253(CH352 PCI based Multi-I/O Controller)
> > is a example. It use UART_IER_UUE as the LOWPOWER function,
> > you can get the datasheet from below urls:
> > 
> > http://wch-ic.com/download/list.asp?id=116
> > CH352DS1.PDF
> > 
> > http://wch-ic.com/download/list.asp?id=117
> > CH352DS2.PDF.
> 
> Rather than quote links that will expire and no longer be
> valid in six months, it would be better if you described
> exactly how and why these ports are different directly in
> your commit long log.

Device 4348:3253 use the UART_IER_UUE
as the LOWPOWER function , so it is readable and writable,
quote out the origin words in datasheet.

"
LOWPOWER:When the bit is 1, close the internal benchmark clock
of serial port to set into low-power status.
"

That is  the convict cause our XScale detect code work wrong.

> What does your change do to Xscale that do not do UART_IER_RTOIE?
Yes, you are right, I don't have experience with Xscale, so I will
fix the problem in another way, set it fix type in 8250_pci code 
maybe is good.

Thanks.

