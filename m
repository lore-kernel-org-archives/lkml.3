Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab3E1CcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:32:15 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:39240 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab3E1CcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130525195601.GJ7660@sirena.org.uk>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
	<20130522161422.GP1627@sirena.org.uk>
	<CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
	<20130525195601.GJ7660@sirena.org.uk>
Date: Tue, 28 May 2013 10:32:09 +0800
Message-ID: <CAK=oMXeCUgc5E1ZaXcbrbUB6XGD135a7zRD-CC5apEytx2j=fw@mail.gmail.com>
Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
From: yi zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, cxie4@marvell.com,
        jett.zhou@marvell.com, linux-kernel@vger.kernel.org,
        Yi Zhang <yizhang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, Brown:

2013/5/26 Mark Brown <broonie@kernel.org>:
> On Fri, May 24, 2013 at 11:01:45AM +0800, yi zhang wrote:
>> 2013/5/23 Mark Brown <broonie@kernel.org>:
>> > On Wed, May 22, 2013 at 08:10:53PM +0800, yizhang.mrvl@gmail.com wrote:
>
>> >> +static const unsigned int BUCK1_table[] = {
>> >> +     /* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
>> >> +     /* 0x50-0x7F: from 1.6 to 1.8V with step 0.05V */
>
>> > Write this out as code, don't use a big table for large sets of
>> > voltages.
>
>>      The voltage table is "const", if we write it out as code, seems
>> it's hard for us
>>      to keep this attribute;
>>      And the voltage of this BUCK is not linear(it's separated as two parts),
>>      seems I shouldn't use the framework helpers to implement it; Right?
>>       what do you think?
>
> You should open code the mapping functions but you should still do this
> as calcuations, it's faster and produces smaller code.  You'll need a
> small function with an if statement.
          Sorry I'm a little confused:
          You mean I should use a function for example
"create_buck_table()" to create the BUCK voltage table?
           such as:
           void create_buck_table()
           {
                   if (voltage < 1587500) {
                             /* initialize the BUCK_table */
                   } else
                             /* initialize the BUCK_table */
           }

          thanks;
