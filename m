Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3BJKPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 05:15:43 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41654 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3BJKPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 05:15:42 -0500
MIME-Version: 1.0
X-Originating-IP: [1.161.137.134]
In-Reply-To: <20130208112027.GI8879@opensource.wolfsonmicro.com>
References: <1360119305.8965.1.camel@phoenix>
	<1360119412.8965.3.camel@phoenix>
	<20130208112027.GI8879@opensource.wolfsonmicro.com>
Date: Sun, 10 Feb 2013 18:15:41 +0800
Message-ID: <CAFRkauD3F-s3PZs9xiDznwpH82V7iEDShUq-SuHmTN68A+=CSQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: s5m8767: Fix using wrong dev argument at
 various places
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/8, Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Feb 06, 2013 at 10:56:52AM +0800, Axel Lin wrote:
>
>> Use &pdev->dev rather than iodev->dev for dev_err(), dev_warn() and
>> dev_info().
>
> It's not clear to me that this is actually an improvement, the pdev is
> mostly just an internal Linux implementation detail so it's common to
> use the physical device for MFD logging in order to help the user
> understand what's causing the log message.

My understanding is if people (at least it's me) found some error message
in dmesg, they usually grep the driver that emit the error message.
If we use the parent device here, people might grep wrong files.

>
>> Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
>> of_get_regulator_init_data(), this fixes memory leak.
>
> This is a good fix though.  This sort of thing is one reason for
> splitting out unrelated changes.

Ok. I'll resend the patchs (for one topic a patch) a few days latter.
(It's Chinese New Year vacation in Taiwan now.)
