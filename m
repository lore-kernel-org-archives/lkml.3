Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936067AbaH0V6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:58:34 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50521 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809AbaH0V6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140822171210.GD27616@saruman.home>
References: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
	<20140822171210.GD27616@saruman.home>
Date: Wed, 27 Aug 2014 14:58:30 -0700
Message-ID: <CAAW3YpZPOCkTkx=OM_0ZYA7brh5t32miprstLqGyurD9vN94yg@mail.gmail.com>
Subject: Re: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
From: Todd Poynor <toddpoynor@google.com>
To: balbi@ti.com
Cc: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Ruchi Kandoi <kandoiruchi@google.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:12 AM, Felipe Balbi <balbi@ti.com> wrote:
...
> you never explain why this is needed and you have also added some
> information to commit log which shouldn't be here.

Android uses this to prevent suspend from interfering with USB
peripheral traffic, notably adb.

The wakeup source is held only when USB is connected and enumerated
for a host session (I might be using wrong terminology here).  It may
not be necessary on a platform that implements wakeup on incoming USB
traffic, although it is likely adb and other protocols would need to
hold wakeup sources at certain times.

...
>> +static struct otgws_lock vbus_lock;
>
> should be per-PHY

One of the reasons this was done as a separate driver and via
notifiers was to keep the (original Android wakelock) logic out of the
USB code.  If the general idea is something that finds favor with the
USB and PM folks then perhaps adding a wakeup source per PHY in the
PHY driver would be better.


Todd
