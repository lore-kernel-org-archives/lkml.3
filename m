Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaBNJC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:02:26 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59821 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaBNJCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:02:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140212175018.GJ28112@sirena.org.uk>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
	<20140212175018.GJ28112@sirena.org.uk>
Date: Fri, 14 Feb 2014 09:02:20 +0000
X-Google-Sender-Auth: r4jLbzJKeyZCKfrz6vJLyJSo_Gc
Message-ID: <CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 5:50 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Feb 12, 2014 at 04:02:40AM +0000, Laszlo Papp wrote:
>
>> +const struct regmap_config max665x_regmap_config = {
>> +     .reg_bits = 5,
>> +};
>
> This would normally be static too, and I'd *really* expect to see a
> val_bits set here.  I'm a bit surprised this works without one.

Makes sense, thanks. Shall I also set the .max_register or any other
mandatory variables in here?

>> +     mutex_init(&max665x->iolock);
>
> What is this needed for?

It was done for consistency with the other mfd drivers (maxim), e.g.
8997 or 8998 as the closest resemblence in this family. Would you
prefer me removing this mutex locker?
