Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918Ab3HTJTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:19:54 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62065 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3HTJTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:19:53 -0400
Message-ID: <521334C6.4070605@gmail.com>
Date: Tue, 20 Aug 2013 11:20:06 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 06/17] ARM: imx: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130820072642.GJ31036@pengutronix.de> <52132D6C.2080606@gmail.com> <20130820091000.GK31036@pengutronix.de>
In-Reply-To: <20130820091000.GK31036@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 11:10 AM, Sascha Hauer wrote:
> On Tue, Aug 20, 2013 at 10:48:44AM +0200, Sebastian Hesselbarth wrote:
>> On 08/20/2013 09:26 AM, Sascha Hauer wrote:
>>> On i.MX5 the init_time hook calls mx5x_clocks_init_dt which calls
>>> mx5x_clocks_init which not only calls of_clk_init() but also registers
>>> all clocks in the system. You can't remove it.
>>>
>>> I am missing some
>>>
>>> CLK_OF_DECLARE(imx51, "fsl,imx51-ccm", imx51_clocks_init);
>>> CLK_OF_DECLARE(imx53, "fsl,imx53-ccm", imx53_clocks_init);
>>>
>>> Somewhere.
>>
>> Sascha,
>>
>> you are right, I forgot to add the two lines above as replacement for
>> the now removed direct call. If the general approach is accepted, I'll
>> add them for sure.
>>
>> Do imx51/imx53 still boot with CLK_OF_DECLARE added?
>
> I can test this once the whole series arrived here. So far I only have
> 6/16 and 10/17. I probably need at least 1/17.

Yeah, I am having troubles with linux-arm-kernel rejecting my mails
because of a suspicious header. I have no clue, what has changed lately
with my mails sent by git send-email to make them get stuck.

I didn't add all sub-arch maintainers to the whole set, that would
have been simply too many.

You need patches [1], [2], and 6 for imx which I will send a v2 in
a second. Ok for you to get them from lkml?

Sebastian

[1] https://lkml.org/lkml/2013/8/19/591
[2] https://lkml.org/lkml/2013/8/19/592

