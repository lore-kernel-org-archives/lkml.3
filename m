Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaGBPva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:51:30 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49505 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbaGBPv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140702072338.GC10311@lee--X1>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
	<1403898973-19571-3-git-send-email-dianders@chromium.org>
	<20140702072338.GC10311@lee--X1>
Date: Wed, 2 Jul 2014 08:51:28 -0700
X-Google-Sender-Auth: TUNaYF-Cw9w2_4JeFILmW11-Q38
Message-ID: <CAD=FV=VRA-WLgxqQ37naFLcoBM3fBM8FWPcLv8X_wZ89wiV4KA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: cros_ec: Use the proper size when looking at the
 cros_ec_i2c result
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>,
        Simon Glass <sjg@chromium.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Olof Johansson <olof@lixom.net>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Wed, Jul 2, 2014 at 12:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 27 Jun 2014, Doug Anderson wrote:
>
>> We know how many bytes the EC should be sending us (which is also the
>> number of bytes transferred) and also how many bytes the EC actually
>> wanted to send to us.  When computing the checksum and copying back
>> data let's make sure we take the lesser of the two of those.  We'll
>> also complain if the EC tried to send us too many bytes.  The EC
>> sending us too few bytes is legit for when we send the EC an invalid
>> command.
>>
>> This is based on similar code in cros_ec_spi.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mfd/cros_ec_i2c.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>
> Is this patch orthogonal i.e. can it be applied without the other two
> patches?

Yes.  If patch 3/3 had worked out then it would have required patch #1
for proper functioning and patch #2 (this patch) to avoid an ugly
error message in the log.  ...but patch #1 and this patch both can
stand on their own and can be applied.

-Doug
