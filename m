Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaJUMXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:23:16 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36110 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaJUMXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:23:12 -0400
Date: Tue, 21 Oct 2014 13:22:29 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Greg KH <greg@kroah.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Touch processing on host CPU
Message-ID: <20141021132229.37a1197c@alan.etchedpixels.co.uk>
In-Reply-To: <20141017171756.GA22238@dtor-ws>
References: <5440F282.8040306@itdev.co.uk>
	<20141017171756.GA22238@dtor-ws>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you will have touch processing in a binary blob, you'll also be going
> to ages "Works with Ubuntu 12.04 on x86_32!" (and nothing else), or
> "Android 5.1.2 on Tegra Blah (build 78912KT)" (and nothing else).

As well as not going upstream because there is no way anyone else can
test changes to the code, or support it. Plus of course there are those
awkward questions around derivative work boundaries that it is best the
base kernel keeps well clear of.

If the data format is documented to the point someone can go write their
own touch processor for the bitstream then that really deals with it
anyway. Given the number of these things starting to pop up it would
probably be good if someone did produce an open source processing engine
for touch sensor streams as it shouldn't take long before its better than
all the non-free ones 8).

Given how latency sensitive touch is and the continual data stream I
would be inclined to think that the basic processing might be better in
kernel and then as an input device - providing it can be simple enough to
want to put kernel side.

Otherwise I'd say your bitstream is probably something like ADC data and
belongs in IIO (which should also help people to have one processing
agent for multiple designs of touch, SPI controllers etc)

Alan





