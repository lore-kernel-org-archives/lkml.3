Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3BYJ1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:27:39 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:44176 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab3BYJ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:27:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130222103306.GA19796@opensource.wolfsonmicro.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
	<1360933026-30325-2-git-send-email-lee.jones@linaro.org>
	<20130220131912.GB13049@sirena.org.uk>
	<CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
	<20130222103306.GA19796@opensource.wolfsonmicro.com>
Date: Mon, 25 Feb 2013 10:27:36 +0100
Message-ID: <CAPDyKFpJzuzB_7=eH7iNV69TLOTbdBCTx3CgqPTkianZCctKag@mail.gmail.com>
Subject: Re: [PATCH 01/35] mfd: ab8500-gpadc: Implemented suspend/resume
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com, arnd@arndb.de,
        linus.walleij@stericsson.com,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 February 2013 11:38, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Feb 21, 2013 at 11:45:08PM +0100, Ulf Hansson wrote:
>> On 20 February 2013 14:19, Mark Brown
>
>> > This doesn't look especially sane...  You're doing a runtime get, taking
>> > the lock without releasing it and disabling the regulator.  This is
>> > *very* odd, both the changelog and the code need to explain what's going
>> > on and why it's safe in a lot more detail here.
>
>> You need to do pm_runtime_get_sync to be able to make sure resources
>> (which seems to be only the regulator) are safe to switch off. To my
>> understanding this is a generic way to use for being able to switch
>> off resources at a device suspend when runtime pm is used in
>> conjunction.
>
> Are you sure this actually does what you think it does, especially when
> run on modern kernels?

Not sure, what you are thinking of more precisely here. Runtime pm has
been in the kernel for quite some time now.

Anyway, to make it a bit clearer, we switch the regulator on/off at
the runtime suspend/resume callbacks. We want to take similar actions
in device suspend/resume.
To accomplish this a pm_runtime_get_sync is done in suspend and vice
verse in resume, otherwise you can not safely handle the regulator.

Kind regards
Ulf Hansson
