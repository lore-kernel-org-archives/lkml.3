Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaB1BYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:24:17 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60254 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB1BYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:24:15 -0500
MIME-Version: 1.0
In-Reply-To: <1393545229.24588.147.camel@joe-AO722>
References: <1393531019-25134-1-git-send-email-florian.vaussard@epfl.ch>
	<1393531808.24588.119.camel@joe-AO722>
	<530F9F03.40803@epfl.ch>
	<1393545229.24588.147.camel@joe-AO722>
Date: Thu, 27 Feb 2014 19:24:14 -0600
X-Google-Sender-Auth: -CMSpt_sJlMonShC3J4nSLZlzUM
Message-ID: <CAL_JsqLnMyHGsv7L64FxooH0jaRjjF8uE=d=n6C84+hYB+ryVQ@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: fix spurious vendor compatible warnings
From: Rob Herring <robh@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Florian Vaussard <florian.vaussard@epfl.ch>,
        Andy Whitcroft <apw@canonical.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 5:53 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-02-27 at 21:24 +0100, Florian Vaussard wrote:
>> On 02/27/2014 09:10 PM, Joe Perches wrote:
>> > On Thu, 2014-02-27 at 20:56 +0100, Florian Vaussard wrote:
>> >> With a compatible string like
>> >> compatible = "foo";
>> >> checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
>> >> which is wrong since the vendor prefix is empty in this specific case.
> []
>> > Some vendor names have dashes.
>> > I don't know if underscores are allowed.
>> >
>> > $ grep -rP --include=*.[ch] -oh "compatible\s*=\s*\"[^,]+,\w" * | \
>> >   sed -r -e 's/\s//g' -e 's/,.$//' | sort | uniq -c | grep "[_-]"
>> >       1 compatible="active-semi
>> >       8 compatible="asahi-kasei
> []
>> In ePAPR v1.1, I could not find any strict requirement. It
>> is just saying:
>>
>> The recommended format is "manufacturer,model", where manufacturer is a
>> string describing the name of the manufacturer (such as a stock ticker
>> symbol), and model specifies the model number.
>
> Should there also be a check in .c and .h files for
>         .compatible = "somestring"

Ideally, yes. I didn't do that because I figured there would be too
many variations in formatting compared to dts files.

> and
>         OF_DEV_AUXDATA("somestring",,,,)

Probably not. OF_DEV_AUXDATA is hopefully temporary. There are 156
instances now and it looks like they've been going down since 3.8.

Rob
