Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359Ab3JPSNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:13:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:44915 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935349Ab3JPSNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:13:35 -0400
Subject: Re: [PATCH] powerpc/qe_lib: Share the qe_lib for the others architecture
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20131015131606.GA2700@book.gsilab.sittig.org>
Date: Wed, 16 Oct 2013 13:12:59 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Scott Wood <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Xie Xiaobo <X.Xie@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <385E3F55-85BB-4E28-A396-FA54DEE1B1AB@kernel.crashing.org>
References: <1381750622-1150-1-git-send-email-X.Xie@freescale.com> <8559CF98-88E4-4271-A873-1409359EFE5C@kernel.crashing.org> <3F4D4A39-3063-45F5-8B0E-3CD5F36B4035@kernel.crashing.org> <20131014200952.GA20517@kroah.com> <20131015131606.GA2700@book.gsilab.sittig.org>
To: Gerhard Sittig <gsi@denx.de>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 15, 2013, at 8:16 AM, Gerhard Sittig wrote:

> On Mon, Oct 14, 2013 at 13:09 -0700, Greg Kroah-Hartman wrote:
>> 
>> On Mon, Oct 14, 2013 at 02:40:44PM -0500, Kumar Gala wrote:
>>> 
>>> Greg,
>>> 
>>> Wondering your thoughts on drivers/qe vs something like
>>> drivers/soc/fsl/qe.  The QuiccEngine (qe) is a communication core on
>>> some of the Freescale networking SoCs that provides the ability to do
>>> various networking/communication functionality.  "Channels" on the QE
>>> can be used for various different things from ethernet, ATM, UART, or
>>> other functions.
>> 
>> What makes the code "QE" specific?  Are these devices that live on the
>> QE "bus", or are they controlling the QE controller?
> 
> You may think of the QUICC as a "programmable bitbang machine" if
> you like.  The very same component runs arbitrary and rather
> different protocols depending on how you setup its parameters.
> 
> There have been serial controllers capable of different protocols
> like UART or SPI or I2S, but all of them are "serial
> communication".  There have been memory controllers which could
> bitbang different protocols (NAND, NOR/SRAM, DRAM), but all of
> them are "memory".
> 
> The QUICC is just a little more versatile, and appears to cover
> cases which reside in different Linux kernel subsystems (like:
> it's neither serial nor network exclusively, but can be either
> and potentially more).
> 
> IIUC the question which Kumar Gala was asking is where to put
> code for the component which is neither a strict subset of any
> subsystem.  Please correct me if I'm wrong.

Thanks for the description.

Yeah, the actual ethernet, usb, serial drivers that exist with QE live today in proper drivers/ dirs.  This is the infrastructure that those drivers utilize that isn't quite related to an existing subsystem.  Mostly set up of channel state/cfg/etc.

- k