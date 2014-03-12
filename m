Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaCLRNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:13:38 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61363 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaCLRNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140312124901.GQ28112@sirena.org.uk>
References: <1394626865-15105-1-git-send-email-jcmvbkbc@gmail.com>
	<1394626865-15105-2-git-send-email-jcmvbkbc@gmail.com>
	<20140312124901.GQ28112@sirena.org.uk>
Date: Wed, 12 Mar 2014 21:13:35 +0400
Message-ID: <CAMo8Bf+mC_ZfECqJ2Apf5rcTJ10hbE55wN1cT7Jv74kzWFuVTg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: add xtfpga SPI controller driver
From: Max Filippov <jcmvbkbc@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-spi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:49 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Mar 12, 2014 at 04:21:03PM +0400, Max Filippov wrote:
>
>> +     case 16:
>> +             /* Bytes that should go out earlier have lower addresses,
>> +              * but the hardware operates with 16 bit words and transmits
>> +              * higher bits first. Thus data in memory is in BE order.
>> +              */
>> +             xspi->data = (xspi->data << 16) | be16_to_cpu(v);
>> +             xspi->data_sz += 2;
>> +             break;
>
> Are you sure you need to do this byte swap?  SPI words are big endian so
> if you are running on a little endian processor if you are transmitting
> 16 bit words you should see the data getting swapped on the bus (this is
> why I say you should never have more than 8 bits per word for regmap).

Looks like this swap is not needed: I've looked at drivers that set
bits_per_word = 16, they submit data in cpu endianness. Will fix in v3.

-- 
Thanks.
-- Max
