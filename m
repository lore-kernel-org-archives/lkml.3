Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaDRVIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:08:02 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61696 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140418185225.GA12304@sirena.org.uk>
References: <1397845810-17002-1-git-send-email-tim.kryger@linaro.org>
	<20140418185225.GA12304@sirena.org.uk>
Date: Fri, 18 Apr 2014 14:07:58 -0700
Message-ID: <CAAYSxhoXvpxphks9p2Y8f0yUUp-4PeOjd2JiSYpsd_qvrRh6vA@mail.gmail.com>
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

Are you saying that REGULATOR_CHANGE_VOLTAGE and
REGULATOR_CHANGE_CURRENT are nonsense?

It does seem like, even in the non-DT case, that the decision of
whether to call the underlying set_voltage and set_current functions
could be made solely based on the numerical voltage and current
constraints.

Thanks,
Tim
