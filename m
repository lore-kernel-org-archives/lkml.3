Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaAHVdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:33:41 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:57627 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaAHVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140108210228.GO27432@n2100.arm.linux.org.uk>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
	<20140108143529.GB14122@mudshark.cambridge.arm.com>
	<CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
	<20140108192028.GM27432@n2100.arm.linux.org.uk>
	<CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
	<20140108210228.GO27432@n2100.arm.linux.org.uk>
Date: Wed, 8 Jan 2014 13:33:35 -0800
X-Google-Sender-Auth: ZDw4UIrrVKLYcmTHEUGunZXigNw
Message-ID: <CAD=FV=WV+1S65zwKRAuOfSnWzWxT_NNpYHUcj6bVyyRNXUfcGw@mail.gmail.com>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Wed, Jan 8, 2014 at 1:02 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 08, 2014 at 11:43:29AM -0800, Doug Anderson wrote:
>> Olof came up with the idea that you could update the RW firmware
>> (affects initial boot) and then cache away the value and restore it in
>> the kernel after resume.  That would still require a kernel patch but
>> perhaps a less objectionable one.  ...of course if writing this
>> register is a problem in secure mode then maybe that patch would be
>> NAKed anyway.
>
> It's not a problem in secure mode, since secure mode will have access
> to the register.  It's the non-secure mode where various registers
> either ignore writes, or they trigger an exception that are the problem.
>
> Consider what would happen if an exception were to be triggered when no
> exception handlers were installed (eg, because the MMU is not enabled.)

OK, good to know.  ...so if someone wanted to code up this patch and
send upstream they would be able to.  :)

-Doug
