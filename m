Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaIBNsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:48:17 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58927 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaIBNsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:48:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robherring2@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC PATCH 1/1] drivers: introduce ARM SBSA generic UART driver
Date: Tue, 02 Sep 2014 15:48:06 +0200
Message-ID: <3749748.k4a1nSHDdj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_Jsq+Rs5MXC7s7EeWAEAPxxqaShAVGt=cdQxud5Us+-Zp6jw@mail.gmail.com>
References: <1409328803-1953-1-git-send-email-andre.przywara@arm.com> <540596A6.8000608@arm.com> <CAL_Jsq+Rs5MXC7s7EeWAEAPxxqaShAVGt=cdQxud5Us+-Zp6jw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lAxjBo0TQKl9x3ztsrqp33HWUfknkEtHF+E4XZ24LTh
 pu3RaTs6kU/FkU1dW99sXUblFdzijurwFraI75bRmWQQWVf1aE
 5hNbNYfaCCG7ByqKfX/D1P+bYJkmq9Wr3kkM42zg9rFnY/ZhDz
 3hBxI6E1AkU1p66LC9bqeLTKgi1JHeMX/EMp5ZE4JahisrFhOQ
 g8/VsMPr/pfNPn7RmeiIojcvFDVSVe5VtX8SfiQIdtY0Os6aP0
 lZursSpLKWpkiMML5mWvQ8UrfNG5JU+jyp6SfWjRsg2d5mcqXp
 qRUCmgqZlImxV0TkI1YWLqQ4iqDowL7IqgiLvzqmsx5CqN9/2/
 NPSv/viurtXMKmK+UBbI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 September 2014 08:20:53 Rob Herring wrote:
> >>
> >> This alone is not okay. There is no such implementation of hardware.
> >
> > But the SBSA explicitly allows this. I don't know of any vendor who just
> > implements the subset, but I've been told that this has been asked for.
> 
> To use baudrate as an example, that must be configurable somehow
> either with pl011 registers or in a vendor specific way. I suppose you
> could do an actual implementation with all those things hardcoded in
> the design, but that seems unlikely.

Why does the baudrate need to be configurable? I think it's completely
reasonable to specify a console port that has a fixed (as in the
OS must not care) rate, and that can be implemented either as a UART
with a programmable rate or as a set of registers that directly talks
to a remote system management device over whatever hardware protocol
they choose.

> >> The DT must specify the implementation such as pl011.
> >
> > If it is a full featured PL011: sure. Then we don't need this driver at
> > all and just use the SBSA UART spec as a guideline for our earlycon
> > implementation.
> > I will try to learn if there is someone actually implementing only the
> > subset.
> 
> I would have assumed you knew someone is. Otherwise, I don't really
> think anything should be implemented at this point. Perhaps adding
> SBSA uart as an explicit earlycon option would be worthwhile. Also, we
> should consider using ttySx instead of ttyAMAx for SBSA compliant
> systems (including ones with pl011).

What about systems that have both a SBSA debug port and a 8250
compatible UART? That sounds like a very realistic hardware design
choice for someone coming from an older x86/powerpc/mips/... chip
that has 8250 and adds the extra port for SBSA compliance.

	Arnd
