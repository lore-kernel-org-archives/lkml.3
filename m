Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3ISFdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 01:33:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51590 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3ISFdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 01:33:45 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130919051611.GA4363@gmail.com>
References: <1379393047-11772-1-git-send-email-zubair.lutfullah@gmail.com> <1379393047-11772-3-git-send-email-zubair.lutfullah@gmail.com> <20130918042726.GB13196@core.coreip.homeip.net> <20130918065406.GA13451@gmail.com> <53771776-0d33-436d-9687-995ed0d6345d@email.android.com> <20130918141533.GA16424@core.coreip.homeip.net> <b37c9a0e-36ed-49bf-bb68-453c7b07b437@email.android.com> <20130918162442.GA14803@core.coreip.homeip.net> <c141b8a3-1e5d-406c-bcc4-ef0abec56192@email.android.com> <20130919051611.GA4363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
From: Jonathan Cameron <jic23@kernel.org>
Date: Thu, 19 Sep 2013 06:33:37 +0100
To: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Message-ID: <39ea39e8-2d11-4c84-ac49-33fdcfa870ed@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Zubair Lutfullah :" <zubair.lutfullah@gmail.com> wrote:
>On Wed, Sep 18, 2013 at 06:05:12PM +0100, Jonathan Cameron wrote:
>> 
>> >> >However in this case such conversion us dangerous. With all but
>IRQ
>> >> >resource managed by the traditional methods they will be released
>> >first
>> >> >with IRQ handler deregistered very last. Therefore if device is
>not
>> >> >properly quiesced IRQ raised during driver unbinding is likely to
>> >> >result
>> >> >in kernel oops.
>> >> >
>> >> >IOW devm_request_irq() is very often evil (it is still useful if
>> >_all_
>> >> >your resources are managed by devm_*).
>> >> >
>> >> >In case of your driver I'd recommend switching to
>> >> >request_irq()/free_irq() instead.
>> >> >
>> >> >Thanks.
>> >> 
>> >> Pretty much all resources are devm managed in here
>> >> 
>> >>
>>
>>https://git.kernel.org/cgit/linux/kernel/git/jic23/iio.git/tree/drivers/iio/adc/ti_am335x_adc.c?h=togreg&id=7a1aeba7ed0d5a1e83fd5a8ee2a2869430d40347
>> >
>> >
>> >So we are guaranteed that that new kfifo that is being allocated
>just
>> >before we requesting IRQ and will be freed way before we free the
>IRQ
>> >will not be used by the IOTQ handler?
>> >
>> >Thanks.
>> Good point. I forgot about that.  The source of interrupts 'should'
>be disabled before the kfifo is freed but I guess perhaps better to
>play it safe. Would take a fair bit of review to be sure that is not
>going to cause grief.
>> 
>> A few more devm handlers need writing before it is truly useful here.
>> 
>> Thanks for pointing this out.
>> 
>> J
>
>If I understand the conclusion correctly, no devm here?

No devm for the irq. The rest are fine.
>
>Zubair
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
