Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaHXAsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 20:48:45 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:60772 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHXAso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 20:48:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140823145404.GI24407@sirena.org.uk>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
	<1408741894-24879-2-git-send-email-atull@opensource.altera.com>
	<20140822214417.GC24407@sirena.org.uk>
	<alpine.DEB.2.10.1408221927370.2334@shineypoop>
	<53F89E8C.3070200@roeck-us.net>
	<20140823145404.GI24407@sirena.org.uk>
Date: Sat, 23 Aug 2014 19:48:43 -0500
Message-ID: <CANk1AXRag72MOf1c4_BBAXG38UKHxfs+hjsAu67xa-aU8JNqGw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] pmbus: add regulator support
From: Alan Tull <delicious.quinoa@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, atull <atull@opensource.altera.com>,
        jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 9:54 AM, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Aug 23, 2014 at 07:00:44AM -0700, Guenter Roeck wrote:
>> On 08/22/2014 05:31 PM, atull wrote:
>
>> >of_get_regulator_init_data() will only have an error if it cannot alloc
>> >the regulator_init_data struct.  That's why I did -ENOMEM.  If there
>> >is no platform data and nothing about the regulator in the device tree, we
>> >should end up with a zeroed out regulator_init_data.
>
>> Yes, but if OF is not defined it will return NULL as well. Unless I am
>> missing something, that means that the code will now fail if there is
>> no platform init data and OF is not configured.
>
> Indeed, and that's the more interesting case than running out of memory.

Thanks for catching this.  I'll remove the unnecessary check for NULL
and the brackets here.

Alan
