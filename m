Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab3BYOwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:52:51 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:63762 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab3BYOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:52:49 -0500
MIME-Version: 1.0
In-Reply-To: <20130225135123.GA28907@opensource.wolfsonmicro.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
	<1360933026-30325-2-git-send-email-lee.jones@linaro.org>
	<20130220131912.GB13049@sirena.org.uk>
	<CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
	<20130222103306.GA19796@opensource.wolfsonmicro.com>
	<CAPDyKFpJzuzB_7=eH7iNV69TLOTbdBCTx3CgqPTkianZCctKag@mail.gmail.com>
	<20130225135123.GA28907@opensource.wolfsonmicro.com>
Date: Mon, 25 Feb 2013 15:52:46 +0100
Message-ID: <CAPDyKFp3RPXnwzQR4r5ubZtOxazagqOQc=0=dA6ohFe4vN65Hg@mail.gmail.com>
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

On 25 February 2013 14:51, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Feb 25, 2013 at 10:27:36AM +0100, Ulf Hansson wrote:
>> On 22 February 2013 11:38, Mark Brown
>
>> > Are you sure this actually does what you think it does, especially when
>> > run on modern kernels?
>
>> Not sure, what you are thinking of more precisely here. Runtime pm has
>> been in the kernel for quite some time now.
>
> Yes, thanks - I was aware of that.  The integration between runtime and
> system PM has been an area that's had some development though.
>
>> Anyway, to make it a bit clearer, we switch the regulator on/off at
>> the runtime suspend/resume callbacks. We want to take similar actions
>> in device suspend/resume.
>> To accomplish this a pm_runtime_get_sync is done in suspend and vice
>> verse in resume, otherwise you can not safely handle the regulator.
>
> Are you absolutely positive that with modern kernels your get actually
> resumes the device?

Yes, runtime resume is always ok, But you can not runtime suspend the
device, since the device suspend layer prevent this with a
pm_runtime_get_noresume before calling the device suspend callback.

Kind regards
Ulf Hansson
