Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3DVSlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 14:41:47 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40723 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3DVSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 14:41:45 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, <gregkh@linuxfoundation.org>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [RFC/PATCHv2 5/5] arm: omap2+: omap_device: remove no_idle_on_suspend
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
	<1366638237-6880-6-git-send-email-sourav.poddar@ti.com>
	<517545C2.3080006@ti.com>
Date: Mon, 22 Apr 2013 11:41:41 -0700
In-Reply-To: <517545C2.3080006@ti.com> (Grygorii Strashko's message of "Mon,
	22 Apr 2013 17:14:26 +0300")
Message-ID: <87y5ca76hm.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> On 04/22/2013 04:43 PM, Sourav Poddar wrote:
>> Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since
>> driver should be able to prevent idling of an omap device
>> whenever required.
>>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Rajendra nayak <rnayak@ti.com>
>> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>> ---
>> Hi Kevin,
>>
>> I have put this as an RFC, due to few comments on cover letter of
>> the previous version by Grygorii Strashko.
>> As, he has mentioned that there are Audio playback use cases which
>> also requires "no_idle_on_suspend" and using them on mainline after
>> this series can cause regression.
>>
>> What you think will be the right approach on this in relation to this patch?
>> I mean every driver(if possible) should  prevent
>> runtime PM for no_idle_on_suspend usecase and we get
>> rid of this OMAP_DEVICE_NO_IDLE_ON_SUSPEND check? OR we should
>> drop this patch as of now?

This is the correct approach, and AFAICT you've fixed the *mainline*
users of this patch which is the important part.  If there are other
mainline users of this feature, we need to know about them.

Let me be clear: this OMAP_DEVICE_NO_IDLE_ON_SUSPEND feature is a hack
(it was introduced by me, but still a hack.)  We've found a way to
handle using the generic framework, and we should move to that.  There
are already a handful of complications when combining runtime PM and
system suspend, and this is just another one.  It makes the most sense
for this handling to be in the drivers themselves.  IOW: if the driver
wants to refuse to runtime suspend (during system suspend), it has the
choice.

>> Hi Grygorii,
>>
>> Is it possible to handle ABE no_idle_on_suspend uscase the way I am
>> trying to handle it for UART in the 2nd patch of this series?
> Unfortunately, I don't know ASOC details (my part is PM),  but from
> the first look it
> will be not easy, because map4-dmic have no Runtime PM handlers at
> all, for example ((

Are those drivers upstream?  If so, please point them out and show how
this feature is being used in *mainline* by those drivers.

For OMAP PM, we have been very clear for a long time all of our PM was
based on runtime PM.  Any drivers that are not runtime PM are broken and
need to be fixed.

As long as Sourav is fixing up all the mainline users of this feature, my
plan to merge/ack the changes unless there are some good arguemnts based
on *upstream* users of the feature.

Kevin

