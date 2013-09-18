Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3IRR3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:29:36 -0400
Received: from mta1.parkeon.com ([91.121.43.66]:33981 "EHLO mta1.parkeon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3IRR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:29:35 -0400
Message-ID: <5239DBDE.7010709@parkeon.com>
Date: Wed, 18 Sep 2013 18:59:10 +0200
From: Martin Fuzzey <mfuzzey@parkeon.com>
Reply-To: mfuzzey@parkeon.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [11/51] Input: atmel_mxt_ts - Implement CRC check for configuration
 data
References: <1372337366-9286-12-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1372337366-9286-12-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/13 14:48, Nick Dyer wrote:
> The configuration is stored in NVRAM on the maXTouch chip. When the device is
> reset it reports a CRC of the stored configuration values. Therefore it isn't
> necessary to send the configuration on each probe - we can check the CRC
> matches and avoid a timeconsuming backup/reset cycle.
>
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>
> -static unsigned mxt_extract_T6_csum(const u8 *csum)
> +static u16 mxt_extract_T6_csum(const u8 *csum)
>   {
>   	return csum[0] | (csum[1] << 8) | (csum[2] << 16);
>   }

Shouldn't this be u32?
It's losing data causing the checksums not to match for me.

