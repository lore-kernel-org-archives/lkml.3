Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaKZMXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:23:46 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:47158 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKZMXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:23:44 -0500
Date: Wed, 26 Nov 2014 12:23:20 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: georg@schorsch-tech.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Comedi device layered on top of FT232RL
Message-ID: <20141126122320.4051857f@lxorguk.ukuu.org.uk>
In-Reply-To: <34ec4bedbde2ede76f23b31e337bb37f.squirrel@wm.schorsch-tech.de>
References: <34ec4bedbde2ede76f23b31e337bb37f.squirrel@wm.schorsch-tech.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 15:39:28 +0100
georg@schorsch-tech.de wrote:

> Hi LKML,
> right now i try to understand if the following thing is possible:
> 
> I have an embedded device with an FT232RL interface which gets
> handled by ftdi_ser.ko. I can with userspace tools talk to it over
> /dev/ttyUSB0. The device control some digital inputs/outputs and some
> ADC/DACs. All is handled over a serial protocol.
> 
> I thought about following options:
> 1.Userspace daemon which sits on /dev/ttyUSB0
>   Pro: Easy to implement
>   Con: It would not be an comedi device and thus not able to use the
>        comedi features
> 
> 2.Kernel driver:
>   Pro: It would be possible to use the comedi interface
>   Con: I would duplicate much of the code used for ftdi_ser.ko.
> 
> OFC i would like to avoid code duplication but i would like to use the
> features and interface from comedi.
> 
> What is the recommended way to solve such issue?

That depends a lot on the protocol and interface. If the Comedi interface
over the ftdi is a serial protocol then the right way to use it is
to write a line discipline. It can then sit on top of the existing serial
drivers and will also conveniently work with any other kind of tty serial
driver (or even ptys) which can be useful if you need to remote control
devices etc.

Alan
