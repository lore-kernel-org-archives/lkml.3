Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab3CDUIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:08:47 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:43424 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3CDUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <201303042054.16849.PeterHuewe@gmx.de>
References: <1362408106-8632-1-git-send-email-peter.huewe@infineon.com>
 <20130304174104.GA10811@ennui.austin.ibm.com> <201303042054.16849.PeterHuewe@gmx.de>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Mon, 4 Mar 2013 14:08:15 -0600
Message-ID: <CAM0nabEZvLSKYSQ7YvxZwtiHn5-Z2FXAEjGDgzPN9T1=LQq12w@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH v2] tpm: Add support for new Infineon I2C
 TPM (SLB 9645 TT 1.2 I2C)
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, Kent Yoder <key@linux.vnet.ibm.com>,
        Peter Huewe <peter.huewe@infineon.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >
>> > +
>> > +#ifdef CONFIG_OF
>> > +static const struct of_device_id tpm_tis_i2c_of_match[] = {
>> > +   { .compatible = "infineon,tpm_i2c_infineon", .data = (void *)0 },
>> > +   { .compatible = "infineon,slb9635tt", .data = (void *)0 },
>> > +   { .compatible = "infineon,slb9645tt", .data = (void *)1 },
>>
>>   Here "name" and "type" are left empty in of_device_id. Will there be
>> times when those are needed? Like informational messages from the OF
>> subsystem?
>
> Hmm, what do you propose?
> name = chip type ? or name = tpm_i2c_infineon?
> type = tpm ?

  Doesn't matter to me, I just wanted to be sure you hadn't missed anything.

>> > +              .of_match_table = of_match_ptr(tpm_tis_i2c_of_match),
>>
>>   Please put this line inside an ifdef CONFIG_OF, since of_match_ptr
>> lives in there.
> NACK.
> of.h has already the ifdef CONFIG_OF for of_match_ptr and defines it either as
>
> #define of_match_ptr(_ptr)      (_ptr)
> or
> #define of_match_ptr(_ptr)      NULL
> depending on CONFIG_OF is set.

  Thanks.

>>   Won't you also need to add OF to Kconfig?
> Not really, as the only stuff we're using is the compatible id - the driver can
> live without it and can be probed from userspace or plain old platform data.
> I probably have compile tested it with and without CONFIG_OF.

  Ok.

> Is it worth a v3?
>  or a small update patch which adds the of name/type and the space? (I can
> create this patch immediately)

  Not a problem, I can apply as-is with the fixup.

Kent

>
> Thanks,
> Peter
>
>
>
