Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaCFVKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:10:22 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63518 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCFVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140305232513.GA9542@earth.universe>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
	<1394052739-8589-2-git-send-email-marek@goldelico.com>
	<20140305232513.GA9542@earth.universe>
Date: Thu, 6 Mar 2014 22:10:19 +0100
Message-ID: <CAAfyv34X1naNEyht0q+bD3QUjCxLJribmfWfZkP073WS7ve4kA@mail.gmail.com>
Subject: Re: [PATCH v2] power: twl4030-madc-battery: Convert to iio consumer.
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Thu, Mar 6, 2014 at 12:25 AM, Sebastian Reichel <sre@debian.org> wrote:
> Hi Marek,
>
> I just have one comment:
>
> On Wed, Mar 05, 2014 at 09:52:17PM +0100, Marek Belisko wrote:
>> [...]
>> -static int madc_read(int index)
>> +static int madc_read(struct iio_channel *channel)
>>  {
>> -     struct twl4030_madc_request req;
>> -     int val;
>> -
>> -     req.channels = index;
>> -     req.method = TWL4030_MADC_SW2;
>> -     req.type = TWL4030_MADC_WAIT;
>> -     req.do_avg = 0;
>> -     req.raw = false;
>> -     req.func_cb = NULL;
>> -
>> -     val = twl4030_madc_conversion(&req);
>> -     if (val < 0)
>> -             return val;
>> -
>> -     return req.rbuf[ffs(index) - 1];
>> +     int val, err;
>> +     err = iio_read_channel_processed(channel, &val);
>> +     if (err < 0) {
>> +             pr_info("Error:%d\n", err);
>
> This should be "Error: %d\n" (with a space).
Ups this is remain from debugging messages. I'll remove it and re-post patches.
Thanks.
>
> Apart from that you should use dev_info() or dev_err(), so that the
> message is properly prefixed by the device. Currently there is no
> hint where this error message is generated.
>
>> +             return err;
>> +     }
>> +     return val;
>>  }
>> [...]
>
> After fixing this you can add
>
> Reviewed-By: Sebastian Reichel <sre@debian.org>
>
> -- Sebastian

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
