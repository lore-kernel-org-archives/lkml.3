Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaFCJ63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:58:29 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57122 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaFCJ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:58:27 -0400
Message-ID: <538D9C42.9040707@gmail.com>
Date: Tue, 03 Jun 2014 12:58:26 +0300
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/base: Replace alias if it already exists
References: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com>	<20140602145959.7E669C426F6@trevor.secretlab.ca>	<538CA125.7090906@gmail.com> <20140603085325.490A1C4096E@trevor.secretlab.ca>
In-Reply-To: <20140603085325.490A1C4096E@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On  3.06.2014 11:53, Grant Likely wrote:

> So, if I understand correctly, the .dtsi file sets up aliases like so:
>
> aliases {
> 	i2c0 = &i2c1;
> 	i2c1 = &i2c2;
> 	i2c2 = &i2c3;
> 	i2c3 = &i2c4;
> 	i2c4 = &i2c5;
> };
>
> and the board file does this:
>
>
> aliases {
> 	i2c1 = &i2c1;
> 	i2c2 = &i2c2;
> 	i2c3 = &i2c3;
> 	i2c4 = &i2c4;
> 	i2c5 = &i2c5;
> };
>
> Which results in a dtb that looks like this:
>
> aliases {
> 	i2c0 = &i2c1;
> 	i2c1 = &i2c1;
> 	i2c2 = &i2c2;
> 	i2c3 = &i2c3;
> 	i2c4 = &i2c4;
> 	i2c5 = &i2c5;
> };
>
> Do I understand correctly?
>

I guess this is the resulting dtb, at least kernel assigns "incorrect" 
index(0) only to i2c1 bus.

> The way aliases works, it is completely valid to have multiple aliases
> pointing at the same node. There are also no ordering guarantees about
> which comes first, so though this patch might work for you at the
> moment, there is no guarantee that it will continue to do so. If the
> i2c0 alias is invalid for that platform, then it must be removed.
>

I see.

> Unfortunately, the overlays have no mechanism for removing properties at
> this time. Can you try putting the following into your board dts file
> and see if it works?
>
> aliases {
> 	i2c0;		/* Deactivate the old alias by making it blank */
> 	i2c1 = &i2c1;
> 	i2c2 = &i2c2;
> 	i2c3 = &i2c3;
> 	i2c4 = &i2c4;
> 	i2c5 = &i2c5;
> };
>
> g.
>

Will do, as soon as I get back home.

Thanks,
Ivo
