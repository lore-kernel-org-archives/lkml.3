Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaJIJA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:00:56 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35324 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaJIJAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:00:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410081240110.4292@nanos>
References: <1412760595-3935-1-git-send-email-lftan@altera.com>
	<1412760595-3935-22-git-send-email-lftan@altera.com>
	<alpine.DEB.2.11.1410081240110.4292@nanos>
Date: Thu, 9 Oct 2014 17:00:41 +0800
X-Google-Sender-Auth: X9i0ToELX7T71TNF5ZOCI1AFfHA
Message-ID: <CAFiDJ58FoP8JhEe8ue5vqvRkz7YggcVps=j1cboQnZUEcL3yQA@mail.gmail.com>
Subject: Re: [PATCH v4 21/29] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 6:44 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 8 Oct 2014, Ley Foon Tan wrote:
>> +static void nios2_timer_set_mode(enum clock_event_mode mode,
>> +     struct clock_event_device *evt)
>> +{
>> +     unsigned long period;
>> +     struct nios2_clockevent_dev *nios2_ced = to_nios2_clkevent(evt);
>> +     struct nios2_timer *timer = &nios2_ced->timer;
>> +
>> +     switch (mode) {
>> +     case CLOCK_EVT_MODE_PERIODIC:
>> +             period = DIV_ROUND_UP(timer->freq, HZ);
>> +             nios2_timer_config(timer, period, CLOCK_EVT_MODE_PERIODIC);
>> +             break;
>> +     case CLOCK_EVT_MODE_ONESHOT:
>> +             nios2_timer_config(timer, ULONG_MAX, CLOCK_EVT_MODE_ONESHOT);
>
> What's the point of this? This should simply stop the timer.
Okay, will change this.

Regards
Ley Foon
