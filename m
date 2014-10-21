Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaJUITM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:19:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:57492 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJUITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:19:09 -0400
Date: Tue, 21 Oct 2014 10:19:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Shao <huishao@microsoft.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
Message-ID: <alpine.DEB.2.11.1410210946470.5308@nanos>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com> <alpine.DEB.2.11.1410202027220.5308@nanos> <alpine.DEB.2.11.1410202034150.5308@nanos> <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Thomas Shao wrote:
> > I still do not have a consistent argument from you WHY you need to abuse
> > do_adjtimex() to do that host - guest synchronization in the first place.
> > 
> 
> I need a function to gradually slew guest time. do_adjtimex() provides all the 
> functionality. Also I could not find any other exposed func to do this. I'd like to
> hear any feedback from you for this.

As Richard and others told you already, there are various options:

1) Use NTP on that private network, which does not involve any kernel
   changes at all.

   Your argument, that this is hard for IT-Admins to set up is just
   ridiculous. If an IT-Admin is not able to set that up, then he
   should better stay away from setting up a guest in the first place,
   really.

2) As pointed out already by others PPS/PTP might be a proper solution
   for this.

   All it takes is a pair of timestamps (host/guest) injected into the
   proper subsystem and a controlling daemon on the guest side. That
   would also avoid the problem of running NTPd and your kernel side
   poor mans NTPd at the same time.

   That pseudo NTP thing is just hilarious, really.

   You take the host time stamp in timesync_onchannelcallback() and
   schedule work. From the work queue you correlate the host time
   stamp to the current time of the guest. So you correlate time
   stamps which can be an arbitrary time apart. Brilliant solution
   that, really.

Thanks,

	tglx

