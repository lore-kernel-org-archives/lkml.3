Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab3LKTx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:53:58 -0500
Received: from lmv.inov.pt ([146.193.64.2]:32855 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab3LKTx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:53:56 -0500
Message-ID: <52A8C25A.6000403@inov.pt>
Date: Wed, 11 Dec 2013 19:51:54 +0000
From: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK
References: <1386760273-7703-1-git-send-email-jose.goncalves@inov.pt> <20131211192954.GA21751@roeck-us.net>
In-Reply-To: <20131211192954.GA21751@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (lmv.inov.pt [146.193.64.2]); Wed, 11 Dec 2013 19:51:55 +0000 (WET)
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-2013 19:29, Guenter Roeck wrote:
> On Wed, Dec 11, 2013 at 11:11:13AM +0000, José Miguel Gonçalves wrote:
>> Some I2C bus drivers do not allow zero-length data transfers which are
>> required to start a measurement with the HIH6130/1 sensor. Nevertheless,
>> we can overcome this limitation by writing a zero dummy byte. This byte
>> is ignored by the sensor and was verified to be working with the OMAP
>> I2C bus driver in a BeagleBone board.
>>
>> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> Applied, after simplifying write_length initialization a bit.
>
> Should this go to -stable ?

Any BeagleBone user that tries to use this sensor will encounter this issue. As 
this board is very popular, this will potentially solve the problems of many 
users. Nevertheless, it does not seems to me that this patch fixes "something 
critical", which is one of the conditions to be accepted in the -stable tree.

José Gonçalves
