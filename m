Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004AbaJUECX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:02:23 -0400
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:62931 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730AbaJUECW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:02:22 -0400
Date: Mon, 20 Oct 2014 23:02:13 -0500
From: Jeff Epler <jepler@unpythonic.net>
To: Thomas Shao <huishao@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Message-ID: <20141021040212.GA6278@unpythonic.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 03:18:58AM +0000, Thomas Shao wrote:
> In some situation, the user is not able to enable guest VM to sync with external 
> time source, like NTP. But the host is still synced with a trusted time source. 
> In this case, host-guest time synchronization is useful.

It's interesting to imagine that a virtualization host could present a
time service to the guest *userspace*, even when the guest is not
otherwise exposed to the internet at large.  This could take the form of
an NTP server on a private network, or as an implementation of a time
source directly usable by ntpd in the guest, for instance as an emulated
serial port with synthetic NEMA GPS signal + PPS signal, for instance.
