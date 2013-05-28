Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3E1TtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:49:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45378 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3E1TtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:49:13 -0400
Date: Tue, 28 May 2013 15:48:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] timekeeping: sync persistent clock and
 RTC on system time step changes
Message-ID: <20130528194849.GA25032@phenom.dumpdata.com>
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
 <1368467768-2316-3-git-send-email-david.vrabel@citrix.com>
 <5191880F.3030308@linaro.org>
 <5192082D.4020400@citrix.com>
 <5192711B.1070607@linaro.org>
 <5193606502000078000D64E2@nat28.tlf.novell.com>
 <5193CFA2.8010008@linaro.org>
 <51A4F6C6.8080808@citrix.com>
 <20130528183137.GA23213@phenom.dumpdata.com>
 <51A500DA.9000708@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A500DA.9000708@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 12:09:14PM -0700, John Stultz wrote:
> On 05/28/2013 11:31 AM, Konrad Rzeszutek Wilk wrote:
> >On Tue, May 28, 2013 at 07:26:14PM +0100, David Vrabel wrote:
> >>On 15/05/13 19:10, John Stultz wrote:
> >>>Ok, so really, as soon as the Dom0 time is set by NTP, all guests will
> >>>see the right time? That makes more sense, and means the window for
> >>>these sorts of issues is reasonably quite small.
> >>It's a small window but it's occurring in our automated test system.
> >>
> >>>David: So I'm less inclined to merge this individual change, but if you
> >>>still feel strongly about it, let me know and we can circle around on it
> >>>after you've addressed the specific issues I pointed out earlier.
> >>This patch was the actual bug fix but I've reworked it to use the
> >>pvclock_gtod notifier chain as this seemed to be what KVM hosts were
> >>using to maintain a clock for guests.  Please review the new series, thanks.
> >Looks good.
> >
> >John if you are OK I am thinking to push this to Linus shortly as it is
> >fixing a bug.
> 
> I'm really not sure I'd call this a bug.  That seems like an
> over-reaction to a misconfigured system.
> 
> Or if there is a bug, I'm not sure its been clearly explained.

The #1 patch - b/c you try to set the RTC time and it actually never takes. Meaning
on the next time the machine is booted the time is again off.
> 
> thanks
> -john
> 
> 
> 
