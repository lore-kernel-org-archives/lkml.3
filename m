Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3GJN5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:57:15 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52778 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3GJN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:57:14 -0400
Message-ID: <51DD6832.1060707@gmail.com>
Date: Wed, 10 Jul 2013 08:57:06 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Popov <a13xp0p0v88@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>, Chris Ball <cjb@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Timur Tabi <timur@tabi.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 2/2] powerpc/512x: add LocalPlus Bus FIFO device driver
References: <1373451678-20065-1-git-send-email-a13xp0p0v88@gmail.com> <20130710134624.GC2615@book.gsilab.sittig.org>
In-Reply-To: <20130710134624.GC2615@book.gsilab.sittig.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 08:46 AM, Gerhard Sittig wrote:
> On Wed, Jul 10, 2013 at 14:21 +0400, Alexander Popov wrote:
>>
>> This is SCLPC device driver for the Freescale MPC512x.
>> It is needed for Direct Memory Access to the devices on LocalPlus Bus.
>>
>> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
>> ---
>>  arch/powerpc/boot/dts/mpc5121.dtsi            |   8 +-
>>  arch/powerpc/include/asm/mpc5121.h            |  32 ++
>>  arch/powerpc/platforms/512x/Kconfig           |   6 +
>>  arch/powerpc/platforms/512x/Makefile          |   1 +
>>  arch/powerpc/platforms/512x/mpc512x_lpbfifo.c | 485 ++++++++++++++++++++++++++
>>  5 files changed, 531 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c
>>
>> diff --git a/arch/powerpc/boot/dts/mpc5121.dtsi b/arch/powerpc/boot/dts/mpc5121.dtsi
>> index bd14c00..6e0b0c0 100644
>> --- a/arch/powerpc/boot/dts/mpc5121.dtsi
>> +++ b/arch/powerpc/boot/dts/mpc5121.dtsi
>> @@ -261,7 +261,13 @@
>>  		/* LocalPlus controller */
>>  		lpc@10000 {
>>  			compatible = "fsl,mpc5121-lpc";
>> -			reg = <0x10000 0x200>;
>> +			reg = <0x10000 0x100>;
>> +		};
>> +
>> +		sclpc@10100 {
>> +			compatible = "fsl,mpc512x-lpbfifo";

The binding needs to be documented.

Rob

