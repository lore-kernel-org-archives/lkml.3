Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab3FEWUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:20:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58521 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab3FEWUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:20:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch drivers which lockup during suspend/resume.
Date: Thu, 06 Jun 2013 00:29:34 +0200
Message-ID: <4207662.oRJambEty7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAME+o4mkBknj0jiUW=Z77fG1bJYy1jHF7=shNQ_ixeL_oJDjFg@mail.gmail.com>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org> <CAME+o4kn=xBToxV2xfC5L0b5wVbQ27EA8+tDt9jT44BvBPeSTA@mail.gmail.com> <CAME+o4mkBknj0jiUW=Z77fG1bJYy1jHF7=shNQ_ixeL_oJDjFg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 05, 2013 03:17:59 PM Zoran Markovic wrote:
> Rafael,

Hi,

> >>> We could do cancel_work_sync() as a recovery, but that call blocks until the
> >>> running async task is flushed, which might never happen. So doing a panic()
> >>> is pretty much the only option for recovering.
> >>
> >> Well, its usefulness is quite limited, then.  That said I'm still not convinced
> >> that this actually is the case.
> >
> > It does block in my environment, AFAICS. Looking a bit further in the
> > code, it looks like dpm_suspend() does an async_synchronize_full()
> > which would wait for all async tasks to complete. This is a
> > show-stopper because (under the circumstances) the assumption that
> > every async suspend routine eventually completes doesn't hold.
> >
> > We could possibly select which async tasks to wait for, but this would
> > add unnecessary complexity to a feature targeted for debugging. It
> > seems that this approach - although sounding reasonable - needs to
> > wait until we have a mechanism to cancel an async task.
> 
> Looks like the implementation of proposal for an async suspend +
> wait_for_completion_timeout is quite complex due to above limitations.
> How do we proceed from here? We have the following options:
> 1. Give up on the idea of having a suspend/resume watchdog.
> 2. Use the timer implementation (with possible modifications).
> 3. Wait for the implementation of (or implement) killing of an already
> running async work.
> 
> Are there any other ideas floating around?

I'm not aware of any at the moment, but I really don't think this is urgent.

I think we can revisit it during the 3.12 cycle and decide how to proceed
then.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
