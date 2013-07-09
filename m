Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3GIHMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:12:10 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:44964
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab3GIHMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:12:07 -0400
Message-ID: <51DBB7C0.4010106@cypress.com>
Date: Tue, 9 Jul 2013 10:12:00 +0300
From: Ferruh Yigit <fery@cypress.com>
Reply-To: <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.input,gmane.linux.kernel
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Javier Martinez Canillas <javier@dowhile0.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Input: cyttsp4 - SPI driver for Cypress TMA4XX touchscreen devices
References: <20130704235117.733726609A1@gitolite.kernel.org> <CAMuHMdXS=35MVinOPNRKi=bAzVpqvL-QEm+QsciO1Xe-BYzc4Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXS=35MVinOPNRKi=bAzVpqvL-QEm+QsciO1Xe-BYzc4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2013 10:15 PM, Geert Uytterhoeven wrote:
> On Fri, Jul 5, 2013 at 1:51 AM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> +++ b/drivers/input/touchscreen/cyttsp4_spi.c
>
>> +static int cyttsp_spi_xfer(struct device *dev, u8 *xfer_buf,
>> +                          u8 op, u8 reg, u8 *buf, int length)
>> +{
>
>> +       if (reg > 255)
>
> As "reg" is "u8", this is never true:
>
> drivers/input/touchscreen/cyttsp4_spi.c: In function ‘cyttsp_spi_xfer’:
> drivers/input/touchscreen/cyttsp4_spi.c:66: warning: comparison is
> always false due to limited range of data type
>
>> +               wr_buf[0] = op + CY_SPI_A8_BIT;
>> +       else
>> +               wr_buf[0] = op;
>
> Can the if-clause and the first branch just be removed, or is there a real bug
> involved (e.g. wrong type for "reg")?

Yes there was a bug here, and already sent a patch for this, please
check https://patchwork.kernel.org/patch/2820561/

thanks,
ferruh


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
