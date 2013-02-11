Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab3BKT5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:57:10 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:44447 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677Ab3BKT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:57:08 -0500
Message-ID: <51194A1F.4060900@ahsoftware.de>
Date: Mon, 11 Feb 2013 20:44:31 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Olaf Titz <olaf@bigred.inka.de>
CC: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>
Subject: Re: MODSIGN without RTC?
References: <5112EA69.6010100@ahsoftware.de> <5112FE21.4020404@ahsoftware.de> <E1U3WSI-00023L-QG@bigred.inka.de>
In-Reply-To: <E1U3WSI-00023L-QG@bigred.inka.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.02.2013 19:44, schrieb Olaf Titz:
>> Another option would be to make a configure option to just ignore the
>> date. I'm not sure if I would like to use MODSIGN when I have to fear
>> that the machine wouldn't start when the RTC fails or got set to a wrong
>> date.
>
> Or just ignore the date unconditionally. After all, when a certificate
> check fails due to out-of-validity-period, then you can always "fix"
> that by appropriately setting the clock. So for security, in this
> application, the date check is outright useless.

I don't think that is an option, because the date check is part of the 
crypto-api and not a part of the modsign-stuff.

So it's necessary that the crypto-api offers a flag to ignore the dates 
and another flag to mark such keys as invalid because of the date. The 
first flag is necessary to load and use the keys, the second flag for 
(maybe) other users of the crypto-api which might not use such invalid keys.

Regards,

Alexander
