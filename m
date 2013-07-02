Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3GBK1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:27:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab3GBK1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:27:10 -0400
Message-ID: <51D2AAF1.4080803@ti.com>
Date: Tue, 2 Jul 2013 15:56:57 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, <spi-devel-general@lists.sourceforge.net>,
        <grant.likely@linaro.org>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: spi: Add qspi flash controller
References: <1372755399-21769-1-git-send-email-sourav.poddar@ti.com> <20130702093247.GY27646@sirena.org.uk> <20130702094404.GL3352@arwen.pp.htv.fi> <20130702101718.GE27646@sirena.org.uk>
In-Reply-To: <20130702101718.GE27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
On Tuesday 02 July 2013 03:47 PM, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 12:44:04PM +0300, Felipe Balbi wrote:
>> On Tue, Jul 02, 2013 at 10:32:47AM +0100, Mark Brown wrote:
>>> Does this hardware really support anything other than 8 bits per word?
>>> There is no code in the driver which pays any attention to the word
>>> size...
>> the HW has a 128-bit shift register ;-) but driver doesn't look
>> complete.
> That's not the issue - remember that SPI specifies big endian byte
> ordering for words on the bus so things will need to be reordered by the
> hardware for anything except 8 bits.
Yes, I defaulted my driver to assume 8 bits.
I will introduce case by case reads based on t->len

Something like..
case 8:
    readb();
case 16:
    readw();
case 32:
    readl();


~Sourav
