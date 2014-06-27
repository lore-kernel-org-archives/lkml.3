Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaF0PtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:49:19 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43589 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaF0PtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140627123443.GC29156@katana>
References: <1403558406-14519-1-git-send-email-dianders@chromium.org>
	<20140627123443.GC29156@katana>
Date: Fri, 27 Jun 2014 08:49:15 -0700
X-Google-Sender-Auth: v-lf5HKFRAItxrBtrub1Uonp7n0
Message-ID: <CAD=FV=WLw2D3sw2LaWt0SJXNEFSBk08eKOCa9O_zt=58UN+MLA@mail.gmail.com>
Subject: Re: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        Randall Spangler <rspangler@chromium.org>,
        Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Bill Richardson <wfrichar@chromium.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Fri, Jun 27, 2014 at 5:34 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Mon, Jun 23, 2014 at 02:20:06PM -0700, Doug Anderson wrote:
>> In <https://lkml.org/lkml/2014/6/10/265> pointed out that the 10-bit
>> flag in the cros_ec_tunnel was useless.  It went into a 16-bit flags
>> field but was defined at (1 << 16).
>>
>> Since we have no 10-bit i2c devices on the other side of the tunnel on
>> any known devices this was never a problem.  Until we do it makes
>> sense to remove this code.  On the EC side the code to handle this
>> flag was removed in <https://chromium-review.googlesource.com/204162>.
>>
>> Reported-by: Dave Jones <davej@redhat.com>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Note that this patch is based atop my current series of posts to
>> cleanup cros_ec.  It wouldn't be hard to apply it to the current ToT
>> if someone wants to land this before the others.
>
> I could take it into my tree, but I think it makes more sense if we
> simply append it to your cleanup series?

Thanks, that sounds reasonable to me.  Lee has Acked the whole series
and Simon Glass has reviewed it too, so I'd imagine that we're just
waiting on the input subsystem's Ack on a few of the patches.

If I happen to send out the other series for some reason I'll tack
this onto the end of it.

-Doug
