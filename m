Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3EQSRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:17:18 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:37512 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3EQSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:17:17 -0400
MIME-Version: 1.0
X-Originating-IP: [84.109.219.89]
In-Reply-To: <1368813500.2194.83.camel@joe-AO722>
References: <1368615236-21345-1-git-send-email-leon@leon.nu>
 <20130516221321.GG22822@zurbaran> <CALq1K=J=Aeg11H5aX8bj-_EowdADJSg5oVY98c1q0v6YbhZEdg@mail.gmail.com>
 <1368813500.2194.83.camel@joe-AO722>
From: Leon Romanovsky <leon@leon.nu>
Date: Fri, 17 May 2013 21:16:56 +0300
Message-ID: <CALq1K=JTcx0i8JVAmjhjQ_f+2AhPcc=Ot15cZd4gmM1krchpoA@mail.gmail.com>
Subject: Re: [PATCH] drivers: mfd: sec-code: Fix sizeof argument
To: Joe Perches <joe@perches.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, sbkim73 <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 8:58 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-05-17 at 20:50 +0300, Leon Romanovsky wrote:
>> On Fri, May 17, 2013 at 1:13 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>> > On Wed, May 15, 2013 at 01:53:56PM +0300, Leon Romanovsky wrote:
>> >> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> []
>> >> @@ -121,7 +121,7 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
> []
>> >> -     pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
>> >> +     pd = devm_kzalloc(dev, sizeof(struct sec_platform_data), GFP_KERNEL);
>> > How is that fixing anything ?
>> Technically you are right, this fix brings code to be align to common
>> code convention and allows to automatic tools  correctly parse it.
>
> Not really.
> Common coding convention is actually the original code.
>
> from: Documentation/CodingStyle:
>
>                 Chapter 14: Allocating memory
> []
> The preferred form for passing a size of a struct is the following:
>
>         p = kmalloc(sizeof(*p), ...);
>
>
Thanks Joe, it is good to know, but from my simple grep, most
developers doesn't follow with this guide:
leon@tux ~/dev/kernel/linux-staging $ grep -r "sizeof(struct" * | wc -l
25865
leon@tux ~/dev/kernel/linux-staging $ grep -r "sizeof(\*" * | wc -l
14568

--
Leon Romanovsky | Independent Linux Consultant
        www.leon.nu | leon@leon.nu
