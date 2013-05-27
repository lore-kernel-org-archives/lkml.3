Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3E0QUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:20:35 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.208]:52179 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab3E0QUb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:20:31 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1369671627!24169796!3
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>
Date: Mon, 27 May 2013 11:17:09 -0500
Subject: RE: [PATCH 02/14] misc/ep93xx_pwm: use {read,write}* instead of
 __raw_* versions for io
Thread-Topic: [PATCH 02/14] misc/ep93xx_pwm: use {read,write}* instead of
 __raw_* versions for io
Thread-Index: Ac5a7X9sKRKxvENHRSW4fBMo6Lht7QACCOxi
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA666D43C@AUSP01VMBX24.collaborationhost.net>
References: <201305241621.50447.hartleys@visionengravers.com>,<201305271718.41851.arnd@arndb.de>
In-Reply-To: <201305271718.41851.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 27, 2013 8:18 AM, Arnd Bergmann wrote:
> On Saturday 25 May 2013, H Hartley Sweeten wrote:
>> @@ -42,13 +42,13 @@ struct ep93xx_pwm {
>>  static inline void ep93xx_pwm_writel(struct ep93xx_pwm *pwm,
>>                 unsigned int val, unsigned int off)
>>  {
>> -       __raw_writel(val, pwm->mmio_base + off);
>> +       writel(val, pwm->mmio_base + off);
>>  }
>
> Just an idea: since you are adding the writel in a lot of places in subsequent
> patches, you could rename 'mmio_base' to the shorter 'base' first, which would
> make the resulting code actually smaller.

Hmm.. It would make the source file a bit smaller but the compiled size would
be the same.

But, I'll probably rename the variable when I convert this driver to the PWM
framework.

Thanks,
Hartley