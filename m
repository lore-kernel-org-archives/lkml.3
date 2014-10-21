Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbaJUQrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:47:16 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:7845 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932373AbaJUQrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:47:15 -0400
Message-ID: <54468E0D.2010200@itdev.co.uk>
Date: Tue, 21 Oct 2014 17:47:09 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Greg KH <greg@kroah.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Touch processing on host CPU
References: <5440F282.8040306@itdev.co.uk>	<20141017171756.GA22238@dtor-ws> <20141021132229.37a1197c@alan.etchedpixels.co.uk>
In-Reply-To: <20141021132229.37a1197c@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/14 13:22, One Thousand Gnomes wrote:
>> If you will have touch processing in a binary blob, you'll also be going
>> to ages "Works with Ubuntu 12.04 on x86_32!" (and nothing else), or
>> "Android 5.1.2 on Tegra Blah (build 78912KT)" (and nothing else).
> 
> As well as not going upstream because there is no way anyone else can
> test changes to the code, or support it. Plus of course there are those
> awkward questions around derivative work boundaries that it is best the
> base kernel keeps well clear of.
> 
> If the data format is documented to the point someone can go write their
> own touch processor for the bitstream then that really deals with it
> anyway. Given the number of these things starting to pop up it would
> probably be good if someone did produce an open source processing engine
> for touch sensor streams as it shouldn't take long before its better than
> all the non-free ones 8).

Thank you for this input, I will feed it back.

> Given how latency sensitive touch is and the continual data stream I
> would be inclined to think that the basic processing might be better in
> kernel and then as an input device - providing it can be simple enough to
> want to put kernel side.

I would think that a touch processing algorithm (including aspects such as
noise and false touch suppression, etc) would be too complex to live
in-kernel. Getting decent performance on a particular device requires a lot
of tuning/customisation.

> Otherwise I'd say your bitstream is probably something like ADC data and
> belongs in IIO (which should also help people to have one processing
> agent for multiple designs of touch, SPI controllers etc)

This sounds promising. The only sticking point I can see is that a touch
frontend has many more channels (possibly thousands), which would seem to
impose a lot of overhead when put into the IIO framework. I will certainly
take a closer look at it.
