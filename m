Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbaITSAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:00:21 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:56489 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaITSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:00:19 -0400
Message-ID: <541DC0AF.2060704@gmail.com>
Date: Sat, 20 Sep 2014 13:00:15 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        gregkh@linuxfoundation.org
CC: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        thomas.ab@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] tty/serial: samsung: Add earlycon support
References: <1410867163-27962-1-git-send-email-alim.akhtar@samsung.com> <541D83AE.1050006@gmail.com>
In-Reply-To: <541D83AE.1050006@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2014 08:39 AM, Tomasz Figa wrote:
> Hi Alim,
> 
> Please see my comments inline.
> 
> On 16.09.2014 13:32, Alim Akhtar wrote:
>> Add earlycon support for the samsung serial port. This allows enabling
>> the samsung serial port for console when early_params are parse and processed.
>>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>  Documentation/kernel-parameters.txt |    6 ++++++
>>  drivers/tty/serial/Kconfig          |    1 +
>>  drivers/tty/serial/samsung.c        |   17 +++++++++++++++++
>>  3 files changed, 24 insertions(+)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 5ae8608..e01c0e5 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -936,6 +936,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  			must already be setup and configured. Options are not
>>  			yet supported.
>>  
>> +		samsung,<addr>

There will only ever be 1 samsung uart? This is an ABI to some extent,
so you will be stuck with it.

>> +			Start an early, polled-mode console on a samsung serial
>> +			port at the specified address. The samsung serial port
>> +			must already be setup and configured. Options are not
>> +			yet supported.
>> +
> 
> Couldn't you simply parse this from DT? I believe there is already code
> parsing stdout property in chosen node for earlycon purposes present in
> the kernel.

You should support both and it is just a OF_EARLYCON_DECLARE line to add.

> Anyway, we already had a patch for this in our internal tree, but it
> wasn't submitted because there was no support for early ioremap on ARM
> at that time. I haven't been following it since then (and I'm no longer
> at Samsung; Marek might be able to take this topic), is it already
> available?

No, but should be soonish. fixmap parts are being worked on by Kees.

Rob

