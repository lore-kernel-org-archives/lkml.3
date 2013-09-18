Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3IRRI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:08:26 -0400
Received: from mta1.parkeon.com ([91.121.43.66]:33579 "EHLO mta1.parkeon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab3IRRIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:08:24 -0400
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 13:08:24 EDT
Message-ID: <5239DDFF.40702@parkeon.com>
Date: Wed, 18 Sep 2013 19:08:15 +0200
From: Martin Fuzzey <mfuzzey@parkeon.com>
Reply-To: mfuzzey@parkeon.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [12/51] Input: atmel_mxt_ts - Download device config using firmware
 loader
References: <1372337366-9286-13-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1372337366-9286-13-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 14:48, Nick Dyer wrote:
> The existing implementation which encodes the configuration as a binary blob
> in platform data is unsatisfactory since it requires a kernel recompile for
> the configuration to be changed, and it doesn't deal well with firmware
> changes that move values around on the chip.
>
> Atmel define an ASCII format for the configuration which can be exported from
> their tools. This patch implements a parser for that format which loads the
> configuration via the firmware loader and sends it to the MXT chip.

I am using the mxt-app tool (v1.13) from 
git://github.com/atmel-maxtouch/obp-utils.git
However when an existing config is dumped using that tool's --save 
option the
config CRC is always zero.

That means that with this patch the config is loaded every time unless the
dumped file is manually tweaked to set the correct CRC.

>
> ---
> -		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
> +	ret = request_firmware(&cfg, MXT_CFG_NAME, dev);
>
When building the driver into the kernel this just hangs for 60 seconds 
then fails.
Wouldn't it be better to use request_firmware_nowait() ?

