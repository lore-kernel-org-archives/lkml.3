Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaF0UsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:48:19 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42352 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaF0UsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:48:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAAfyv36ZdwpoGsARQKRfvX4EeanZVVus5A444KSE8LOmePhyig@mail.gmail.com>
References: <1392387929-31491-1-git-send-email-marek@goldelico.com>
	<530338B2.603@kernel.org>
	<CAAfyv36ZdwpoGsARQKRfvX4EeanZVVus5A444KSE8LOmePhyig@mail.gmail.com>
Date: Fri, 27 Jun 2014 22:48:13 +0200
Message-ID: <CAAfyv34-gTwWU-QZmFFFXnwNeWNjxObVrFkaxN2CNSNuuo_EqQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: iio: hmc5843: Add all available models to
 device tree id table.
From: Belisko Marek <marek.belisko@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PIng? Jonathan do you have any objections to this approach? Can you
please pick it? Thx.

On Tue, Feb 18, 2014 at 9:35 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> Hi Jonathan,
>
> On Tue, Feb 18, 2014 at 11:40 AM, Jonathan Cameron <jic23@kernel.org> wrote:
>> On 14/02/14 14:25, Marek Belisko wrote:
>>>
>>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>>
>> I wonder how this got missed.  However, for those data elements to be
>> useful, you will
>> need to read them somewhere in the driver I think.... (if there is any magic
>> that puts this in the relevant i2c locations then point it out to me!)
> There is a table called hmc5843_chip_info_tbl which contains entries
> for all models
> which this driver can handle. And magic is that correct model variant
> is set probe function:
> line: idata->variant = &hmc5843_chip_info_tbl[id->driver_data];
> (id->driver_data contains model value).
>>
>>> ---
>>>   drivers/staging/iio/magnetometer/hmc5843.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/iio/magnetometer/hmc5843.c
>>> b/drivers/staging/iio/magnetometer/hmc5843.c
>>> index d4f4dd9..f595fdc 100644
>>> --- a/drivers/staging/iio/magnetometer/hmc5843.c
>>> +++ b/drivers/staging/iio/magnetometer/hmc5843.c
>>> @@ -630,7 +630,9 @@ static const struct i2c_device_id hmc5843_id[] = {
>>>   MODULE_DEVICE_TABLE(i2c, hmc5843_id);
>>>
>>>   static const struct of_device_id hmc5843_of_match[] = {
>>> -       { .compatible = "honeywell,hmc5843" },
>>> +       { .compatible = "honeywell,hmc5843", .data = (void *)HMC5843_ID },
>>> +       { .compatible = "honeywell,hmc5883", .data = (void *)HMC5883_ID },
>>> +       { .compatible = "honeywell,hmc5883l", .data = (void *)HMC5883L_ID
>>> },
>>>         {}
>>>   };
>>>   MODULE_DEVICE_TABLE(of, hmc5843_of_match);
>>>
>>
>
> BR,
>
> marek
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
