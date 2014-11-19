Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaKSShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:37:38 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60154 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKSShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:37:37 -0500
Message-ID: <546CE366.1030405@collabora.co.uk>
Date: Wed, 19 Nov 2014 19:37:26 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device interface
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>	<1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk> <20141118170001.6256c6df@lxorguk.ukuu.org.uk>
In-Reply-To: <20141118170001.6256c6df@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

Thanks a lot for your feedback.

On 11/18/2014 06:00 PM, One Thousand Gnomes wrote:
>> +#ifdef CONFIG_COMPAT
>> +struct compat_cros_ec_command {
>> +	uint32_t version;
>> +	uint32_t command;
>> +	compat_uptr_t outdata;
>> +	uint32_t outsize;
>> +	compat_uptr_t indata;
>> +	uint32_t insize;
>> +	uint32_t result;
>> +};
>> +
>> +struct compat_cros_ec_readmem {
>> +	uint32_t offset;
>> +	uint32_t bytes;
>> +	compat_uptr_t buffer;
>> +};
>> 
> 
> This is a new API - arrange them to be 64bit safe and properly padded,
> there is no excuse for needing compat crap except for legacy interfaces
> you can't fix.
> 

Is true that this is a new API for mainline but there is a lot of ChromeOS
installations that depends on this API which means that just replacing the
kernel with a mainline one there, will break existing user-space programs.

But I understand that since those binaries were using a non-ustream kernel
it is expected that the kernel API could be changed.

I think it would be great to keep existing binaries working but if changing
the API is required, then I can certainly do that when doing a re-spin.

Best regards,
Javier
