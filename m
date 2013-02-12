Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab3BLJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:18:19 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:40209 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932131Ab3BLJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:18:17 -0500
Message-ID: <511A08D2.6010104@gaisler.com>
Date: Tue, 12 Feb 2013 10:18:10 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: Create function for counting number of phandles in
 a property
References: <1360540701-23439-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1360540701-23439-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-11 00:58, Grant Likely wrote:
> This patch creates of_count_phandle_with_args(), a new function for
> counting the number of phandle+argument tuples in a given property. This
> is better than the existing method of parsing each phandle individually
> until parsing fails which is a horribly slow way to do the count.
>
> It also converts of_gpio_named_count() to use the new function instead
> of using the above described horrible method.
>
> This also requires the return value of of_gpio_count() &
> of_gpio_named_count() from 'unsigned int' to 'int' so that it can return
> an error code. All the users of that function are fixed up to correctly
> handle a negative return value.

One more thing: In of_spi_register_master() in drivers/spi.c the error 
code is put in the unsigned variable nb, leading to a huge nb and 
master->num_chipselect with following problems when of_gpio_named_count 
returns an error code.

Cheers,
Andreas Larsson

