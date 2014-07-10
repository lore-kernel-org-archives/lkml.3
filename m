Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaGJRHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:07:36 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33890 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGJRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:07:35 -0400
MIME-Version: 1.0
In-Reply-To: <CANcMJZBDyx4KXB18nn=2zO-eEpeq2eL+7mpLhhsgsc632P9uAg@mail.gmail.com>
References: <1326156853-24840-1-git-send-email-dianders@chromium.org>
	<1326492948-26160-1-git-send-email-dianders@chromium.org>
	<CANcMJZBDyx4KXB18nn=2zO-eEpeq2eL+7mpLhhsgsc632P9uAg@mail.gmail.com>
Date: Thu, 10 Jul 2014 10:07:33 -0700
X-Google-Sender-Auth: jAzoby8IbVvRlZNXAQRQ525M9TQ
Message-ID: <CAD=FV=UEsSKuPwuTRMkzHVAsLKeMpffm3MTdicwxtHDLxbCtYg@mail.gmail.com>
Subject: Re: [PATCH v2] of: Support CONFIG_CMDLINE_EXTEND config option
From: Doug Anderson <dianders@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@linaro.org>, Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Thu, Jul 10, 2014 at 12:33 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Fri, Jan 13, 2012 at 11:15 PM, Doug Anderson <dianders@chromium.org> wrote:
>> The old logic assumes CMDLINE_FROM_BOOTLOADER vs. CMDLINE_FORCE and
>> ignores CMDLINE_EXTEND.  Here's the old logic:
>>
>> - CONFIG_CMDLINE_FORCE=true
>>     CONFIG_CMDLINE
>> - dt bootargs=non-empty:
>>     dt bootargs
>> - dt bootargs=empty, @data is non-empty string
>>     @data is left unchanged
>> - dt bootargs=empty, @data is empty string
>>     CONFIG_CMDLINE (or "" if that's not defined)
>>
>> The new logic is now documented in of_fdt.h and is copied here for
>> reference:
>>
>> - CONFIG_CMDLINE_FORCE=true
>>     CONFIG_CMDLINE
>> - CONFIG_CMDLINE_EXTEND=true, @data is non-empty string
>>     @data + dt bootargs (even if dt bootargs are empty)
>> - CONFIG_CMDLINE_EXTEND=true, @data is empty string
>>     CONFIG_CMDLINE + dt bootargs (even if dt bootargs are empty)
>> - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=non-empty:
>>     dt bootargs
>> - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is non-empty string
>>     @data is left unchanged
>> - CMDLINE_FROM_BOOTLOADER=true, dt bootargs=empty, @data is empty string
>>     CONFIG_CMDLINE (or "" if that's not defined)
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> CC: devicetree-discuss@lists.ozlabs.org
>> CC: Grant Likely <grant.likely@secretlab.ca>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: Rob Herring <rob.herring@calxeda.com>
>> ---
>> I didn't hear a response from Ben about whether he was OK with
>> my proposal for how CONFIG_CMDLINE_EXTEND should behave with
>> a non-empty @data, so sending out code that implements my
>> interpretation.  Hopefully this looks OK.
>>
>> Changes in v2:
>> - Removed broken fix for the case when there is no "chosen" attribute.
>> - Changed CONFIG_CMDLINE_EXTEND behavior when @data is a non-empty string.
>
> In reviewing some of the random patches in the Android AOSP common.git
> tree, I noticed this one, and found this discussion which petered out
> without resolution.  Were there any objections still, or did this just
> slip through the cracks?

I gave up and decided not to keep pushing and solved the problem
another way myself.  ...but I still agree that it's a reasonable thing
to do.  I haven't really thought about this in several years now...

I do remember seeing
<https://android-review.googlesource.com/#/c/57349/1/drivers/of/fdt.c>
where Colin looked to be making a bunch of changes to the patch before
merging, but I guess he ended up splitting that into a cleanup patch.
I think I pinged him to ask if he wanted me to get involved in the
review but I got no response.


> Note, there's also this follow-on fix from Colin, which probably
> should be included if the parent patch is merged:
> https://android.googlesource.com/kernel/common.git/+/a2acc58bc7460a03627f20842a7169d7a1328299

OK.  Seems reasonable to me.  I haven't done a full review of all of
the boundary conditions here, but otherwise it looks fine.
