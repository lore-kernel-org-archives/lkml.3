Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3E1S0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:26:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:32798 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3E1S0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:26:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="27808011"
Message-ID: <51A4F6C6.8080808@citrix.com>
Date: Tue, 28 May 2013 19:26:14 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Jan Beulich <JBeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] timekeeping: sync persistent clock and
 RTC on system time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-3-git-send-email-david.vrabel@citrix.com> <5191880F.3030308@linaro.org> <5192082D.4020400@citrix.com> <5192711B.1070607@linaro.org> <5193606502000078000D64E2@nat28.tlf.novell.com> <5193CFA2.8010008@linaro.org>
In-Reply-To: <5193CFA2.8010008@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/13 19:10, John Stultz wrote:
> 
> Ok, so really, as soon as the Dom0 time is set by NTP, all guests will 
> see the right time? That makes more sense, and means the window for 
> these sorts of issues is reasonably quite small.

It's a small window but it's occurring in our automated test system.

> David: So I'm less inclined to merge this individual change, but if you 
> still feel strongly about it, let me know and we can circle around on it 
> after you've addressed the specific issues I pointed out earlier.

This patch was the actual bug fix but I've reworked it to use the
pvclock_gtod notifier chain as this seemed to be what KVM hosts were
using to maintain a clock for guests.  Please review the new series, thanks.

David
