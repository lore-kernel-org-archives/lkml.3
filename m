Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIAL7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:59:41 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:50093 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIAL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:59:40 -0400
Message-ID: <54045FA6.70602@mentor.com>
Date: Mon, 1 Sep 2014 15:59:34 +0400
From: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Dirk Behme <dirk.behme@de.bosch.com>
CC: <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com> <20140829190129.GZ29327@sirena.org.uk> <5404246E.4090908@de.bosch.com> <20140901101512.GK29327@sirena.org.uk>
In-Reply-To: <20140901101512.GK29327@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 02:15 PM, Mark Brown wrote:
> On Mon, Sep 01, 2014 at 09:46:54AM +0200, Dirk Behme wrote:
>> I wonder how this fits to
>
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/gpio/gpio-legacy.txt
>
>> "GPIOs are identified by unsigned integers in the range 0..MAX_INT"
>
>> "If you want to initialize a structure with an invalid GPIO number, use
>> some negative number (perhaps "-EINVAL");"
>
>> then?
>
> There's no practical way to deploy that without breaking users - as soon
> as you treat 0 as a valid GPIO you make all existing users relying on
> the natural behaviour of treating 0 as default instantly buggy which is
> not practical.  Really the GPIO API is badly specified here.
>

Back in the time before DTS conversion started, the 0 was a correct GPIO 
number. If somebody wanted to specify that no gpio is provided, he 
provided -1 as an invalid number. I have the feeling that allowing users 
to use 0 as 'no gpio' is a mistake. Or the API should be changed
to disallow GPIO 0 to exist at all.

-- 
With best wishes
Dmitry
