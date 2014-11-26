Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaKZRGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:06:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33405 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaKZRGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:06:18 -0500
Message-ID: <5476085B.40009@ti.com>
Date: Wed, 26 Nov 2014 19:05:31 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        <linux-i2c@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mike Looijmans <milo-software@users.sourceforge.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio
 for bus recovery
References: <1417010393-30598-1-git-send-email-grygorii.strashko@ti.com> <1417010393-30598-6-git-send-email-grygorii.strashko@ti.com> <20141126160407.GN4431@pengutronix.de>
In-Reply-To: <20141126160407.GN4431@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 06:04 PM, Uwe Kleine-König wrote:
> On Wed, Nov 26, 2014 at 03:59:53PM +0200, Grygorii Strashko wrote:
>> Having a board where the I2C bus locks up occasionally made it clear
>> that the bus recovery in the i2c-davinci driver will only work on
>> some boards, because on regular boards, this will only toggle GPIO
>> lines that aren't muxed to the actual pins.
>>
>> The I2C controller on SoCs like da850 (and da830), Keystone 2 has the
>> built-in capability to bit-bang its lines by using the ICPFUNC registers
>> of the i2c controller.
>> Implement the suggested procedure by toggling SCL and checking SDA using
>> the ICPFUNC registers of the I2C controller when present. Allow platforms
>> to indicate the presence of the ICPFUNC registers with a has_pfunc platform
>> data flag and add optional DT property "ti,has-pfunc" to indicate
>> the same in DT.
> On what does it depend if this pfunc stuff works or not? Only the SoC,
> or also on some board specific properties?

SoC / set of SoCs. Also, similar feature is supported by OMAP and AM335x/AM437x SoCs
using I2C_SYSTEST register.

> Given the former using the
> compatible string to detect its availability would be better. (In this
> case also sorry, didn't consider this case when requesting the property
> in the last round.)
> 
> The patch looks ok.

regards,
-grygorii
