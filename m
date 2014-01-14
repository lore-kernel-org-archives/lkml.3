Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaANWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:46:16 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:37786 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaANWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:46:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAGo_u6oGDK5s0SeE6Z7UFM6eYdgoy-E+Tj67+pBWP-wQ3r9=QA@mail.gmail.com>
References: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org>
	<52D404DE.2020806@ti.com>
	<CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com>
	<52D55CE5.1060902@ti.com>
	<CAA3XUr2cnF_rxMYvZfjBx22Sa8YE45o_qUU8GNoerQwhWqxhNQ@mail.gmail.com>
	<CAGo_u6oKpRFnPAWaqr9NTNAJB+m56jiDgBUgvsiZpaQ-3SF2kw@mail.gmail.com>
	<CAA3XUr1_cNuPmMU6Fs6c7Si2So0VFGcLyGJe+tS_R47BVKRXnw@mail.gmail.com>
	<CAGo_u6p7ErrKOMy4Ljg3nehVpd=DOg3XDn6gZ1nrFE_OuOjsWg@mail.gmail.com>
	<52D5A60C.7080800@ti.com>
	<CAGo_u6oGDK5s0SeE6Z7UFM6eYdgoy-E+Tj67+pBWP-wQ3r9=QA@mail.gmail.com>
Date: Wed, 15 Jan 2014 00:46:12 +0200
Message-ID: <CAArO44tKGZ57-YToTEK_wGtV2WaCXvOWdfqBvHPtJ4=uJCbdgw@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 January 2014 23:13, Nishanth Menon <nm@ti.com> wrote:
> On Tue, Jan 14, 2014 at 3:03 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>>
>>> ok.. some sort of Linaro thing about which I have no background about
>>> - but dont really care in this context.
>>>
>> Nothing related Linaro. Its just that platforms are supporting ARM BE
>> mode and Linaro folks had working patches for Panda. So I suggested
>> to get them on the lists.
>
> I tend to think -> is this with OFF mode and CPUidle completely
> working? All context save and restore works with this? on HS and GP
> devices with BE mode builds? works on SDP4430,60 variations,
> considered reuse with AM43xx which could use parts of that logic?
>
> I mean to indicate that terms like "works on panda" tends always to be relative.

Nishanth, let's be objective here.
CPUidle on 4460 does *not* work in mainline for at least two kernel releases
even for LE [1]. That fix exists because that "one group of folks"
faced the issue
during BE testing. Looks like not much people care about CPUIdle on OMAP4.

> It is nice to see it as a proof of concept, but I'd hate to see some
> dead code lying around in kernel and folks blindly following suit and
> introducing macros for new assembly for a feature that in practice
> just one group of folks care about and creates additional burden for
> rest of folks trying to keep that functionality going as we jump from
> one "device tree" style churn to another "framework"? Not to mean that
> good features should be kept away.. but personally, I could not find
> convincing arguments in this case..

In general I understand your concerns from previous e-mails, but I don't
see a point to spend time for a generic solution for a single user.
If there will be other platforms which need similar changes, then we can
think of some generic solution. Let's drop this patch for now.
We can just disable CPUidle for BE tasks or keep this patch forked.

[1] https://lkml.org/lkml/2013/10/22/401

-- 
Regards,
Taras Kondratiuk
