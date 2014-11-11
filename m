Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaKKVzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:55:50 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:65470 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaKKVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:55:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1411111336010.1356@lava-test-server>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
	<201409251211.57183.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
	<201409261046.07132.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
	<54613259.4070903@opensource.altera.com>
	<alpine.DEB.2.02.1411111336010.1356@lava-test-server>
Date: Wed, 12 Nov 2014 03:25:48 +0530
Message-ID: <CAD6G_RQFV9LfBzVbureBiCneW+PpLzSdUCyz9L6D+EhE4gT+WA@mail.gmail.com>
Subject: Re: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
From: Jagan Teki <jagannadh.teki@gmail.com>
To: Graham Moore <grmoore@opensource.altera.com>
Cc: bpqw <bpqw@micron.com>, Marek Vasut <marex@denx.de>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 01:11, Graham Moore <grmoore@opensource.altera.com> wrote:
> On 11/05/2014 09:09 PM, bpqw wrote:
>> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
>>
>> For Micron SPI NOR flash,enabling or disabling quad I/O protocol is
>> controlled
>> by EVCR (Enhanced Volatile Configuration Register), Quad I/O protocol bit 7.
>> When EVCR bit 7 is reset to 0,the SPI NOR flash will operate in quad I/O
>> mode.
>
> Hi, I'm having trouble with this patch using a Cadence QSPI controller and
> Micron n25q00 part.
>
> I can use quad commands in Extended SPI mode, but I can't make this EVCR Quad
> mode work.
>
> The Cadence QSPI Controller has fields to configure the quad transfer, and can
> support quad opcode, quad address, and quad data, or some combination.  There
> is a chart in the docs which shows the combinations for various read commands.
>
> Problem is, I've tried all of the combinations and all I get is FF with this
> EVCR patch.
>
> If I don't set the quad mode in the EVCR, then I can use quad read commands no
> problem.
>
> Bottom line, with the Cadence QSPI controller, if I use quad commands in
> Extended SPI mode, then all good.  If I use this EVCR quad mode, then all bad.
>
> Anybody else have a Cadence QSPI controller and using EVCR quad mode
> successfully?

I have almost verified all the micros parts for operating quad mode
and the quad enable bit is
volatile by default and no need to set it on software.

Why this code is meant for - does micron has changed this bit
operation on newly added parts?

thanks!
-- 
Jagan.
