Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaGKN6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:58:43 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:40561 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaGKN6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:58:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jul 2014 15:58:37 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: wg@grandegger.com, shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: add vf61x support for flexcan
In-Reply-To: <53BFD401.8030101@pengutronix.de>
References: <1405075933-22317-1-git-send-email-stefan@agner.ch>
 <53BFD401.8030101@pengutronix.de>
Message-ID: <dac76ccd134f41b86f00352d10cfae4b@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

Am 2014-07-11 14:09, schrieb Marc Kleine-Budde:
> IMHO it should be 4 seperate patches:
> - dt
> - clocks
> - flexcan_get_berr_counter fixes
> - your flexcan enhancements

Ok, will split.

>> @@ -362,7 +374,7 @@
>>
>>  			esdhc1: esdhc@400b2000 {
>>  				compatible = "fsl,imx53-esdhc";
>> -				reg = <0x400b2000 0x4000>;
>> +				reg = <0x400b2000 0x1000>;
> 
> What's that doing here? :)

That's an error I just stumbled upon. I know it's not related but it's
such a small change... Do I need to make a separate patch for that or
can I include it in the FlexCAN dt commit?

>> @@ -150,18 +171,20 @@
>>   * FLEXCAN hardware feature flags
>>   *
>>   * Below is some version info we got:
>> - *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
>> - *                                Filter?   connected?
>> - *   MX25  FlexCAN2  03.00.00.00     no         no
>> - *   MX28  FlexCAN2  03.00.04.00    yes        yes
>> - *   MX35  FlexCAN2  03.00.00.00     no         no
>> - *   MX53  FlexCAN2  03.00.00.00    yes         no
>> - *   MX6s  FlexCAN3  10.00.12.00    yes        yes
>> + *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
>> + *                                Filter?   connected?  detection
>> + *   MX25  FlexCAN2  03.00.00.00     no         no	   no
>> + *   MX28  FlexCAN2  03.00.04.00    yes        yes	   no
>> + *   MX35  FlexCAN2  03.00.00.00     no         no	   no
>> + *   MX53  FlexCAN2  03.00.00.00    yes         no	   no
>> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes	   no
>> + *   VFxx  FlexCAN3  ?		     no		no	  yes
> 
> Please use either tabs or space to indent in this table.

Ok, btw, do you know how I can obtain the IP version?

--
Stefan
