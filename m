Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaGPSzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:55:39 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42848 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaGPSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:55:37 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407161400150.1028-100000@iolanthe.rowland.org>
References: <CAE_wzQ82xsuDQrw8Q6auoG9fowr4VZkcUgciPXe2s9PTAmJ=RA@mail.gmail.com>
 <Pine.LNX.4.44L0.1407161400150.1028-100000@iolanthe.rowland.org>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Wed, 16 Jul 2014 11:55:16 -0700
Message-ID: <CAJiQ=7CorBMaO80xcEx4ygYFDJxxav_yyPs2jegKo3vrX1REHA@mail.gmail.com>
Subject: Re: Power-managing devices that are not of interest at some point in time
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dtor@google.com>, Patrik Fimml <patrikf@chromium.org>,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Benson Leung <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 11:08 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> I am not so much concerned about userspace, but about reusing of as
>> much of existing PM framework in the drivers. Right now it is very
>> hard to correctly track dependencies between general open/close,
>> system suspend/resume, and various runtime-PM transitions. Adding yet
>> another PM mechanism into the mix will just add more complexity.
>
> Would it make sense to unbind the drivers for these devices when the
> lid is closed?  With the drivers gone, there would naturally be no I/O
> interactions with the hardware and the class devices would disappear.

FWIW, per your earlier recommendation[1], that is the approach that my
group has been using to disable various host controllers when Linux is
running (not suspended) but certain power-hungry peripherals are not
needed.  It has mostly worked out OK; each driver typically implements
its own special PHY init/shutdown procedure, and calls into the common
clk_* functions to enable/disable the appropriate clocks.

Obviously the application needs to be able to cope with disappearing
devices, and you wouldn't want to have any filesystems mounted on top
of them when the unbind event happens.

Our devices are on an SoC's internal bus, not PCI.

[1] http://lists.linuxfoundation.org/pipermail/linux-pm/2012-April/033976.html
