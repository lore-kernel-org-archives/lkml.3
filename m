Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaJVLBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:01:45 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:64824 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbaJVLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D33BC@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
	<alpine.DEB.2.11.1410202027220.5308@nanos>
	<alpine.DEB.2.11.1410202034150.5308@nanos>
	<CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
	<20141021040212.GA6278@unpythonic.net>
	<20141021082058.GB6808@netboy>
	<CD2CABCB2C0A0D4682C5F8AD840141540D33BC@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Wed, 22 Oct 2014 12:01:43 +0100
Message-ID: <CAL7Bo8EUcmUXhpJvrz_G-Svs+GwSF9CQec5oWWQSYBqWiJYH2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for do_adjtimex()
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get that NTP can be installed locally.  This is how I regulate time
on my guests.  I agree the admin argument probably doesn't stand up.

The problem is hyperv_clocksource (pluggable time source used by
hyperv guests) is systematically fast in my environment. by around
-250 PPM.
I get away with NTP (just).
However others have had to use tickadj to get hyperv_clocksource close
enough for NTP to work i.e. inside +/-500 PPM. (This IS outside normal
admin tasks)

So if we are going to use NTP as the solution for hyperv guests (which
is a valid one) the systematic drift of hyperv_clocksource in
different environments will need to be addressed.  Maybe this patch
could be modified to tune the tick count on boot before NTP starts and
then leave it alone so NTP can take over.
