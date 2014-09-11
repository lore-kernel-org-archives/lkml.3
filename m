Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaIKJyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:54:33 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36161 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaIKJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:54:31 -0400
Message-ID: <54117151.3030601@collabora.co.uk>
Date: Thu, 11 Sep 2014 11:54:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "Bowens, Alan" <Alan.Bowens@atmel.com>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>	 <540ED495.20609@collabora.co.uk> <20140910092832.GM30307@lee--X1> <1410422429.2857.16.camel@collabora.co.uk> <54115F6E.3010007@collabora.co.uk> <5411693A.3050300@itdev.co.uk>
In-Reply-To: <5411693A.3050300@itdev.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nick,

On 09/11/2014 11:19 AM, Nick Dyer wrote:
> 
> Thanks for the clear explanation.
> 
> The i2c aliases are a bit confusing. The original device the driver was
> written for was called qt602240, which was renamed by Atmel to mXT224 when
> the chip series was called "maXTouch". The driver now actually supports
> many other chips which aren't listed (more than 20 devices that I've
> personally tested). I could add them all, but it would be an extremely long
> list. It may be preferable to use the generic name maXTouch.
> 
> So I think the sensible thing to do here would be to add "maxtouch" to the
> i2c list to fix the module autoload issue.
> 

While this will actually fix the module auto-load issue on the atmel driver,
I'm concerned that the I2C core is not reporting the correct module
'of:N*T*Catmel,maxtouch*' alias when probing using DT.

Since as Lee said on his cover letter for the mentioned series [0], an I2C ID
table shouldn't be mandatory for drivers that only support DT based platforms
(e.g: a driver that depends on OF) but in that case I2C module auto-loading
would not work AFAICT.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/6/20/199
