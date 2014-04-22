Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaDVSil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:38:41 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:60225 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaDVSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140418185225.GA12304@sirena.org.uk>
References: <1397845810-17002-1-git-send-email-tim.kryger@linaro.org>
	<20140418185225.GA12304@sirena.org.uk>
Date: Tue, 22 Apr 2014 11:38:38 -0700
Message-ID: <CAAYSxhrzX+bW-94RForJqJQ7K9BtXvUoNz9KC7XBWwACsx7qPA@mail.gmail.com>
Subject: Re: [PATCH] regulator: Allow set voltage on fixed regulators
From: Tim Kryger <tim.kryger@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 11:52 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 18, 2014 at 11:30:10AM -0700, Tim Kryger wrote:
>> If a regulator consumer requests a voltage range that can be satisfied,
>> the return value should indicate success even if that regulator has a
>> fixed voltage.  Since there is already logic to check if the requested
>> voltage range overlaps the allowed range, set REGULATOR_CHANGE_VOLTAGE
>> for regulators with constraints that include a positive voltage.
>
> This seems like the wrong place to fix this, it's nothing to do with DT
> and we shouldn't require that nonsensical permissions are set.  Instead
> we should fix this at the point where we're implementing the permission
> check, have the failure case check the current voltage before returning
> an error.

I now see that Bjorn submitted a patch which did exactly that.

https://lkml.org/lkml/2014/2/5/494

His change made it into v3.15-rc1, so mine is no longer necessary.

Thanks,
Tim Kryger
