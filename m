Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaESMGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:06:48 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64261 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaESMGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:06:45 -0400
Message-ID: <5379F3CE.8030404@linaro.org>
Date: Mon, 19 May 2014 17:36:38 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>, alsa-devel@alsa-project.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        sbkim73@samsung.com, Randy Dunlap <rdunlap@infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
References: <20140424133920.GA12304@sirena.org.uk> <5359E18B.60600@linaro.org> <20140429222915.GU15125@sirena.org.uk> <5360E5E7.8090807@linaro.org> <20140430180314.GA3245@sirena.org.uk> <53623004.5010805@linaro.org> <20140501141510.GW3245@sirena.org.uk> <CAD=FV=Wa4CovkxBng0SkUUAryiFqa=m63tro1Yv1jRgp4e95aw@mail.gmail.com> <20140501164003.GC3245@sirena.org.uk> <53632568.5020200@linaro.org> <20140502165643.GQ3245@sirena.org.uk>
In-Reply-To: <20140502165643.GQ3245@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/02/2014 10:26 PM, Mark Brown wrote:
> On Fri, May 02, 2014 at 10:26:08AM +0530, Tushar Behera wrote:
>> On 05/01/2014 10:10 PM, Mark Brown wrote:
> 
>>> There's patches been posted by (IIRC) Sylvester Nawrocki for
>>> this which I think Mike was basically happy with - I don't
>>> immediately see them in -next though, but I may be looking in
>>> the wrong place.
> 
>> Right, there are some patches from Sylwester regarding this. I
>> dont' think the patches are accepted yet as Rob has some
>> reservations against the clock parents.
> 
>> https://lkml.org/lkml/2014/4/9/173
> 
> Well, OK - that's the bit to fix.  Speaking to Mike the other day
> he said there was also another competing implementation of this.
> 

Instead of setting the parent clock, setting the desired rate on
XCLKOUT works for audio playback.

Will it be okay to do a 'clk_set_rate(mclk, 24000000)' in sound card
driver or should we wait for Sylwester's patch to get merged?

- -- 
Tushar Behera
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTefPOAAoJELqclMPPkq4N6UIH/i5W7KYjyKTQtX+AGdUmJwIx
3TTwyWVz5YQ6gFpLHwwy5AwIkj4mygox2e7l0qWU6yOXCMceaXrvzxOK+B/LRXlp
+s8xjd+C+Idxhs0T6V4GkJRA9jtari3gcIGfz4tFtWY5O0l0eNTUduILhAvmE/Sw
c4m8aOwK33P0kvkTIp/ShSujYa8v82XosMRuf4P0iEz9I3qw3syJkWWvqNZFrnPs
B7i+9ZiZkyttsUVBOAWMBfOdLP5sMtxKDdk1GTkN1plxAE8lKdNVATR5htQL4bxo
ZFcWJxE14pWQ770gEJVXkDT9o8dhmVNrDVp4eGe3m+43gN+Bssh+9kgdxb3vmIY=
=gXaJ
-----END PGP SIGNATURE-----
