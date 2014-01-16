Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaAPLdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:33:18 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43765 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAPLdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:33:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140114210618.GZ15567@sirena.org.uk>
References: <CAK=oMXebE=OKzGbaRH_baOvRyhPXnw0MZuRrcZYLpeR73=XdqA@mail.gmail.com>
	<20140114210618.GZ15567@sirena.org.uk>
Date: Thu, 16 Jan 2014 19:33:13 +0800
Message-ID: <CAK=oMXc1YwQcAEfwzgr9QKVCF8kyT3wH2aubYtMYCcJBxviw6Q@mail.gmail.com>
Subject: Re: [Question] Should we make the primary interrupt handler
 configurable for regmap_add_irq_chip()?
From: Yi Zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yi Zhang <yizhang@marvell.com>, hongfeng@marvell.com,
        linux-kernel@vger.kernel.org, zhouqiao@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/15 Mark Brown <broonie@kernel.org>:
> On Sat, Jan 11, 2014 at 12:15:21PM +0800, Yi Zhang wrote:
>
>> I met a scenario:
>> As soon as the interrupt is triggered, a wakelock is needed to be held
>> until the threaded handler finishes,
>> I think we may hold it in the primary interrupt handler, but now it's
>> NULL by default;
>
> This sounds like something we should just support in the core, though to
Sorry, I'm not clear about this, you mean that this has been supported
in regmap framework?
I searched but didn't find related mail about this, could you please
kindly point out the mail loop?
thanks very much;

> be honest I'd expect the interrupt core to hold a wakelock itself during
> interrupt processing.  If we're doing it in regmap then allowing the
> caller to set a wakelock to hold seems better than making them all write
> the code to take and release it.
