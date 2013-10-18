Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3JRJg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:36:57 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42155 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3JRJgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:36:55 -0400
MIME-Version: 1.0
In-Reply-To: <20131016092310.GD19112@lee--X1>
References: <1381871640-22262-1-git-send-email-linus.walleij@linaro.org>
	<20131016092310.GD19112@lee--X1>
Date: Fri, 18 Oct 2013 11:36:54 +0200
Message-ID: <CACRpkdZ1oZuJWA+S4hY0VDYaGi19Rcn=xSYYUDak7xc+iXB4fA@mail.gmail.com>
Subject: Re: [PATCH 2/5] mfd: tc3589x: detect the precise version
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 15 Oct 2013, Linus Walleij wrote:

>>  static const struct i2c_device_id tc3589x_id[] = {
>> -     { "tc3589x", 24 },
>> +     { "tc35890", TC3589X_TC35890 },
>> +     { "tc35892", TC3589X_TC35892 },
>> +     { "tc35893", TC3589X_TC35893 },
>> +     { "tc35894", TC3589X_TC35894 },
>> +     { "tc35895", TC3589X_TC35895 },
>> +     { "tc35896", TC3589X_TC35896 },
>> +     { "tc3589x", TC3589X_UNKNOWN },
>>       { }
>>  };
>>  MODULE_DEVICE_TABLE(i2c, tc3589x_id);
>
> This is an awful lot of code for what we're trying to achieve.

I am not only trying to achive setting the number of GPIOs right,
I want the system to be aware of exactly which version of the chip
it is dealing with because they all have subtle differences, and
people will run into this in the future when adding more features.
http://www.toshiba-components.com/mobile/data/General_Presentation_IO_Expander_www_Jan_2012.pdf
See table on p.14 for example.

>   1. I guess that other OSes will need to capture the same
>   information, so wouldn't it be prudant to do so via a DT property?
>   That way it's just a one or two liner.

This patch is not about Device Tree. It is about probing from
the device name.

>   2. As we're only using .driver_data for num_gpio at this time, just
>   place them in tc3589x_id as you have done for tc3589x.

This doesn't scale to the other pecularities that differ and I
then just push the problem onto the next person dealing with
this chip.

>   3. Again, as all of this extra code is only used for pulling out
>   num_gpio, group the devices by num_gpio:
>
>> +     switch (id->driver_data) {
>> +     case TC3589X_TC35893:
>> +     case TC3589X_TC35895:
>> +     case TC3589X_TC35896:
>> +             tc3589x->num_gpio = 20;
>> +             break;
>> +     case TC3589X_TC35890:
>> +     case TC3589X_TC35892:
>> +     case TC3589X_TC35894:
>> +     case TC3589X_UNKNOWN:
>> +     default:
>> +             tc3589x->num_gpio = 24;
>> +             break;
>> +     }

This I can do. The switch tree can then be extended as need
be in the future.

Yours,
Linus Walleij
