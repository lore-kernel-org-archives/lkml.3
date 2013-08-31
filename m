Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3HaKud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 06:50:33 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:54560 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab3HaKub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 06:50:31 -0400
Date: Sat, 31 Aug 2013 12:51:28 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: Dove: Add the audio device to the Cubox DT
Message-ID: <20130831125128.0e3a23c7@armhf>
In-Reply-To: <521DCD80.9010105@gmail.com>
References: <20130828113521.35c53365@armhf>
	<521DCD80.9010105@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 12:14:24 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> > +&i2s1 {
> > +	status = "okay";
> > +	pinctrl-0 = <&pmx_audio1_i2s1_spdifo>;
> > +	pinctrl-names = "default";
> > +};  
> 
> Please also add the external clock connected from si5351.

Hi Sebastian and Russell,

I tried it on my Cubox (<&si5351 2>), and I have problems with HDMI
output and some audio streams like webradios with sample rates 32 or
22.05 kHz.

According to the Dove specification, the audio controller works with
the samples rates 44.1, 48 and 96 kHz, so, I don't see the usage of the
external clock, except when using the two audio controllers with
different sample rates.

But, BTW, as the kirkwood-i2 driver is written, this last case does not
work: for 44.1, 48 and 96 kHz, the external clock is never used and
there is only one DCO.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
