Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaJUIXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:23:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:57526 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbaJUIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:23:45 -0400
Date: Tue, 21 Oct 2014 10:23:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Thomas Shao <huishao@microsoft.com>
cc: John Stultz <john.stultz@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Richard Cochran <rcochran@linutronix.de>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D290B@HKXPRD3002MB006.064d.mgd.msft.net>
Message-ID: <alpine.DEB.2.11.1410211020101.5308@nanos>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com> <alpine.DEB.2.11.1410202027220.5308@nanos> <alpine.DEB.2.11.1410202034150.5308@nanos> <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <CALAqxLVKZKQn628ZUa1D9ev37DUz+h4y5AXhMqCg_8dJ7JkEDw@mail.gmail.com> <CD2CABCB2C0A0D4682C5F8AD840141540D290B@HKXPRD3002MB006.064d.mgd.msft.net>
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
> I didn't find a way to detect whether NTPd is running in the hyper-v module.  

And you better do not try at all.
 
> In http://doc.ntp.org/4.1.0/ntpd.htm, it mentioned: Normally, the
> time is slewed if the offset is less than the step threshold, which
> is 128 ms by default, and stepped if above the threshold.
>
> In my implementation, I use 100ms as the threshold (maybe I should
> change to 128?).  If the time difference is less than 100ms, I just
> do nothing. So, if NTPd is running, ideally it could keep the time
> drift less than 128, so the adjustment in my patch will not get
> triggered.

Your implementation has nothing to do with NTP at all. It's not even
close to NTP. It's a random hack to inject host time or slew into
timekeeping with the precision of a random number generator.

> And moreover, by default, the guest-host time sync is turn
> off. There is a module parameter to control it. We'll also document
> customer that do not turn on this if NTP is configured.

Pretty well thought out mechanism to ensure that people will get it
wrong in the first place.

Thanks,

	tglx
