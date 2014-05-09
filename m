Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbaEIUEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:04:51 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:51616 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbaEIUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <536C08B6.2080309@gmail.com>
References: <1399330337-16748-1-git-send-email-tthayer@altera.com>
	<1399330337-16748-4-git-send-email-tthayer@altera.com>
	<536C08B6.2080309@gmail.com>
Date: Fri, 9 May 2014 15:04:47 -0500
Message-ID: <CAF03EBdYhGvpNtw+vzRpxyMSxPQ=rM9Fy8rexg-BKFRmTg4o6Q@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
From: Thor Thayer <tthayer.linux@gmail.com>
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, Borislav Petkov <bp@alien8.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 5:44 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
>
> On 5/5/14 5:52 PM, tthayer@altera.com wrote:
>> From: Thor Thayer <tthayer@altera.com>
>>
>> ---
>> v2: Use the SDRAM controller registers to calculate memory size
>>     instead of the Device Tree. Update To & Cc list. Add maintainer
>>     information.

<snip>

>> +
>> +err2er altr_sdram_edac_driver = {
>> +     .probe = altr_sdram_probe,
>> +     .remove = altr_sdram_remove,
>> +     .driver = {
>> +             .name = "altr_sdram_edac",
>> +             .of_match_table = of_match_ptr(altr_sdram_ctrl_of_match),
> I don't think you need of_match_ptr here for this platform as SOCFPGA is
> only a DT platform. All that of_match_ptr() does for a CONFIG_OF platform
> is just return the pointer.
>
> Dinh

Thanks Dinh. I'll remove it in my next submission.

>> +     },
>> +};
>> +
>> +module_platform_driver(altr_sdram_edac_driver);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_AUTHOR("Altera Corporation");
>> +MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
>
