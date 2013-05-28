Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3E1TGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:06:15 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56339 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3E1TGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:06:14 -0400
Message-ID: <51A50023.8090306@linaro.org>
Date: Tue, 28 May 2013 12:06:11 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] timekeeping: sync persistent clock and
 RTC on system time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-3-git-send-email-david.vrabel@citrix.com> <5191880F.3030308@linaro.org> <5192082D.4020400@citrix.com> <5192711B.1070607@linaro.org> <5193606502000078000D64E2@nat28.tlf.novell.com> <5193CFA2.8010008@linaro.org> <51A4F6C6.8080808@citrix.com>
In-Reply-To: <51A4F6C6.8080808@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 11:26 AM, David Vrabel wrote:
> On 15/05/13 19:10, John Stultz wrote:
>> Ok, so really, as soon as the Dom0 time is set by NTP, all guests will
>> see the right time? That makes more sense, and means the window for
>> these sorts of issues is reasonably quite small.
> It's a small window but it's occurring in our automated test system.

What is it with about your automated test system that causes a 
misconfigured RTC & system such that xen guests are started before Dom0 
has finished being initialized? Or am I still misunderstanding the 
situation?

1) Dom0 boots w/ misconfigured RTC
2) Dom0 starts ntp, correcting the date
3) After 11 minutes of sync the RTC is synced to NTP time.

 From earlier discussions, the only problem would be with guests 
starting between 1 and 2 (which seems a bit early for guests to be 
starting). And after 3, with your patch 1/2 (that I've queued) the issue 
should not recur again, as the RTC is corrected.


>
>> David: So I'm less inclined to merge this individual change, but if you
>> still feel strongly about it, let me know and we can circle around on it
>> after you've addressed the specific issues I pointed out earlier.
> This patch was the actual bug fix but I've reworked it to use the
> pvclock_gtod notifier chain as this seemed to be what KVM hosts were
> using to maintain a clock for guests.  Please review the new series, thanks.

I'm still not convinced that we should be changing the behavior we've 
had for quite a long time.

thanks
-john


