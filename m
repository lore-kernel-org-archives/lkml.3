Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbaGPRMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:12:31 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50507 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440AbaGPRMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:12:25 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407161006260.1028-100000@iolanthe.rowland.org>
References: <20140716013206.GA13409@google.com>
	<Pine.LNX.4.44L0.1407161006260.1028-100000@iolanthe.rowland.org>
Date: Wed, 16 Jul 2014 10:12:23 -0700
X-Google-Sender-Auth: mF9QNTanHVMLQ2QloTfT6u-ypbo
Message-ID: <CANLzEkum3xM5iqXr7W3C0rxWa1SC56Q2hv7aHvut2rOvV098aQ@mail.gmail.com>
Subject: Re: Power-managing devices that are not of interest at some point in time
From: Benson Leung <bleung@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Torokhov <dtor@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 7:17 AM, Alan Stern <stern@rowland.harvard.edu> wrote:

>> Various workarounds cover some of these cases, and we have some ugly
>> hacks in ChromeOS to make things work. It would be nice if a userspace
>> power management daemon could listen to the lid-close event, and then
>> have a way to temporarily power off these devices, potentially through
>> sysfs.
>
> Isn't it common for laptops to go into system suspend when the lid is
> closed?

It's common, but it does not cover all possible cases. As was
mentioned by Dmitry, the user may dock his laptop, close his lid and
use external display, keyboard, and mouse. In that case, the internal
devices should be disabled or else they may send bogus input when the
laptop's B panel couples with the touchpad, for example.

Even in the case where system suspend happens, we don't want to depend
on that state change to disable these devices. It may take some time
before the system enters suspend, and in the meantime the input
devices with the lid closed may inadvertently cancel suspend by
generating a pm_wakeup_event(), which is not what we want.

Other scenarios outside of lid close where such a feature would be
helpful would be for transforming form-factors such as Yoga style
laptops where the screen can fold back into tablet mode, and the C
panel touchpad and keyboard should be disabled.


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
