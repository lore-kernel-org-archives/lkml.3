Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaGSPZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 11:25:13 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33061 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaGSPXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 11:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407191039160.25162-100000@netrider.rowland.org>
References: <1451627.FURGiR949u@dtor-glaptop>
	<Pine.LNX.4.44L0.1407191039160.25162-100000@netrider.rowland.org>
Date: Sat, 19 Jul 2014 08:23:36 -0700
X-Google-Sender-Auth: JyaLwrc_XGN_c8qo2dzRktZz128
Message-ID: <CANLzEkt4g_Y+nC6PSFCch6hR6YSE-S6FBe0Rt=adgWBi3vjM8Q@mail.gmail.com>
Subject: Re: Power-managing devices that are not of interest at some point in time
From: Benson Leung <bleung@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dtor@google.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrik Fimml <patrikf@chromium.org>,
        Bastien Nocera <hadess@hadess.net>, linux-pm@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 7:51 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 18 Jul 2014, Dmitry Torokhov wrote:
>
>> > The area where it must interact with power management is wakeup, both remote
>> > wakeup at run time and wakeup from system suspend.  In particular, there's
>> > the question whether or not a device ignoring its input should be regarded
>> > as a wakeup source.
>>
>> I'd say no.
>
> This raises an interesting question.  Suppose the system gets suspended
> while the lid is closed.  At that point, shouldn't wakeup devices be
> enabled, even if they were already inhibited?

It's possible that this could be a policy decision, ie, whether
power/wakeup is set to enabled for those devices or not.
However, I'd say that there's only one policy that makes sense in that
case : wakeups should be disabled while suspended.

If we inhibited the device during runtime to prevent stray input
events from being generated, it wouldn't make sense to allow the
device to potentially generate an accidental wakeup while suspended.
