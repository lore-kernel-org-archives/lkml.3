Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaHIRP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:15:56 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55820 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaHIRPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:15:54 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E65747.9070108@roeck-us.net>
Date: Sat, 09 Aug 2014 10:15:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        satoru takeuchi <satoru.takeuchi@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>, stable <stable@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
References: <20140808213457.511493898@linuxfoundation.org>	<53E57279.1030106@roeck-us.net>	<20140809034911.GA2348@kroah.com>	<20140809034950.GB2348@kroah.com>	<53E5A0D1.10507@roeck-us.net>	<20140809141609.GA21639@kroah.com>	<53E63871.5040504@roeck-us.net> <CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
In-Reply-To: <CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 09:07 AM, Linus Torvalds wrote:
> On Sat, Aug 9, 2014 at 8:04 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> There are two arm build failures in Linus' tree which are not seen
>> in -next.
>
> Ugh. Did I screw up the semantic merge wrt the devm_phy_create()
> argument changes despite having an example patch from Stephen? Or is
> this something else due to something that just wasn't in -next?
>
> Can you post the build failures?
>

Building arm:multi_v7_defconfig ... failed
Building arm:exynos_defconfig ... failed
--------------
Error log (same for both builds):

ERROR (phandle_references): Reference to non-existent node or label "disp_pd"

ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2

and:

$ git grep disp_pd
arch/arm/boot/dts/exynos5420.dtsi:              samsung,power-domain = <&disp_pd>;

So, yes, disp_pd is not defined.

If I understand -next correctly, it includes a fixup which removes disp_pd
from the file. From the -next build log:

	Applying: ARM: dts: exynos5420: remove disp_pd

Copying Stephen for additional input.

Guenter

