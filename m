Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451Ab3FTLdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:33:17 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52860 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378Ab3FTLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <51C2E0AF.7040702@monstr.eu>
References: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
	<CACRpkdY4xaCOe28nu-NrYQ7pafjhj8-xqFcJRF9iJUy3SrCVrA@mail.gmail.com>
	<51A8387C.4030704@monstr.eu>
	<CACRpkdbHiaK6YPgXyxNgEeZxAsddK4x0vS-q3YfyXnj_BgHvuw@mail.gmail.com>
	<51A852A1.7020505@monstr.eu>
	<CACRpkdbL4pqiF8zxMi28SRTJ9AESiFt0wJMhK1oBio_cfFhpsQ@mail.gmail.com>
	<51C2B47A.6010906@monstr.eu>
	<CACRpkdbWXFLgcUJ-gcUArRotJMoX4JBU9mmheooJBWsLR=QHOA@mail.gmail.com>
	<51C2E0AF.7040702@monstr.eu>
Date: Thu, 20 Jun 2013 13:33:10 +0200
Message-ID: <CACRpkdbcq+e099mT+TVwv9vDjXwkf8QdB_4b4UXuysPF+40oUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] GPIO: Add support for dual channel in gpio-xilinx.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 12:59 PM, Michal Simek <monstr@monstr.eu> wrote:
> On 06/20/2013 11:23 AM, Linus Walleij wrote:

>> What about something like this:
>>
>> static bool is_dual (struct device_node *np)
>> {
>>     struct property *prop = of_find_property(np, "xlnx,is-dual", NULL);
>>     int ret;
>>     u32 val;
>>
>>     if (!prop)
>>         return false;
>>
>>     ret = of_property_read_u32(np, "xlnx,is-dual", &val);
>>     if (ret < 0)
>>         return true; /* node exists but has no cells */
>>
>>     return !!val;
>> }
>
> we can do it in this way but what I don't like on this is that IP
> is design to support 2 channels right now.
> It can happen that Xilinx decides to extend this for new channels.
> Register map is prepared for it and there is enough space to do it.
>
> And when this is done then is-dual (which is current name which
> is used in hardware configuration from design tools) will contain
> larger value >1.
> I agree that is-dual is not the best name.

You don't say. It's about as smart as this:

#define NUMBER_TWO 4

Oh well, that's not your fault.

But seriously:

  xlnx,is-dual;

without an argument can still be taken to mean "2", and
you still need to inperpret the absence if this parameter
as "1" do you not?

> What about to do it differently?
> Generate number of channel in the description.
> And also do for() loop in the probe function to read values based
> on this channel number.

Sorry I can't translate this, can you send a patch?

Yours,
Linus Walleij
