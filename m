Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbbAFVfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:35:23 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:47210 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbbAFVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20150106212255.GV2915@two.firstfloor.org>
References: <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <20150106040428.GR2915@two.firstfloor.org> <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
 <54AC1FFB.7030504@linux.intel.com> <CALCETrVJyBR7NoZvC=A4htRtm-fLe5NUEGUdvJRL28adU4MhUg@mail.gmail.com>
 <54AC29B1.70004@linux.intel.com> <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
 <54AC2F62.40708@linux.intel.com> <20150106191649.GU2915@two.firstfloor.org>
 <CALCETrUNpi1Gc-Qpmu1bJ0BVcSH2xquaY_X+YYhLjbPaQcf0_w@mail.gmail.com> <20150106212255.GV2915@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Jan 2015 13:34:56 -0800
Message-ID: <CALCETrUpR6ZCBSXdbY232inK=LaXLK0LAssqUt+r8DAn9=xjJg@mail.gmail.com>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        ilya.enkovich@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 1:22 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Given that it doesn't seen to have been committed yet, I'm not too
>> worried about compatibility.  And "prctl (43)" doesn't actually seem a
>> whole lot better than "syscall(SYS_arch_prctl, ARCH_ENABLE_MPX, 0)"
>
> This would actually fail with the EINVAL change you requested.
>

So the libmpx code needs to change anyway, then, right?  I really
don't think we should accept garbage in the extra prctl slots just
because uncommitted code somewhere fails to initialize them.

--Andy

>> (preprocessor macros ftw!).  But I don't feel that strongly about this
>> point.
>
> -Andi



-- 
Andy Lutomirski
AMA Capital Management, LLC
