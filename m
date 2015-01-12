Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbbALK2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:28:06 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:18684 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbALK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:28:04 -0500
X-IronPort-AV: E=Sophos;i="5.07,743,1413270000"; 
   d="scan'208";a="54462795"
Message-ID: <54B3A1B0.1010005@broadcom.com>
Date: Mon, 12 Jan 2015 11:28:00 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Benoit Parrot <bparrot@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [Patch v5 2/2] gpio: Document GPIO hogging mechanism
References: <1419019671-25377-1-git-send-email-bparrot@ti.com>	<1419019671-25377-3-git-send-email-bparrot@ti.com> <CACRpkdb7Wq7-rBypqPkefejY5Qfq_KKx91H+DxKWv-TM2y04bg@mail.gmail.com>
In-Reply-To: <CACRpkdb7Wq7-rBypqPkefejY5Qfq_KKx91H+DxKWv-TM2y04bg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/15 11:20, Linus Walleij wrote:
> On Fri, Dec 19, 2014 at 9:07 PM, Benoit Parrot<bparrot@ti.com>  wrote:
>
>> Add GPIO hogging documentation to gpio.txt
>>
>> Signed-off-by: Benoit Parrot<bparrot@ti.com>
>> Reviewed-by: Alexandre Courbot<acourbot@nvidia.com>
>
> This is starting to look good ...
>
>> +               line_b {
>> +                       gpio-hog;
>> +                       gpios =<6 0>;
>> +                       state = "output-low";
>
> I don't like the state string.
>
> Instead have boolean properties for all states.
>
> line_b {
>      gpio-hog;
>      gpios =<6 0>;
>      output-low;
>      line-name = "foo-bar-gpio";
> }
>
> Then use of_property_read_bool() in the code to check which
> state is to be selected intially. You can check that no mutually
> exclusive state are selected, I don't like that an arbitrary string
> select the state like that, if we do it that way an enumerator would
> be better, I prefer bools.

To avoid the mutual exclusive state checking, would it not be more 
straightforward to use numeric enum values defined in boot/dts/include.

Regards,
Arend

> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

