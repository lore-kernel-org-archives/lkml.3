Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaJUIOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:14:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41774 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaJUIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:14:01 -0400
Date: Tue, 21 Oct 2014 10:13:55 +0200
From: Richard Cochran <richardcochran@gmail.com>
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
Message-ID: <20141021081355.GA6808@netboy>
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
> 
> In some situation, the user is not able to enable guest VM to sync with external 
> time source, like NTP. But the host is still synced with a trusted time source. 

But the guest *is* networked, right?

(Otherwise syncing the guest's clock is pointless.)

> I've got some feedbacks from Richard and Mike, including reference NTP implementation
> and do the adjustment in the host side. I've already referenced some NTP design in
> my patch. I would consider my patch as a simplified implementation.

I really don't think we want a half baked servo in some random
driver. Instead, why not present the time difference using a standard
interface?

> I've also considered
> the host side implementation. But in host, we can only set time but not gradually slew/adjust
> time,

Why not implement adjustment in the host?

> which is not acceptable for the time sync solution.We still recommend user to configure
> NTP on the guest, which provides better accuracy. But if NTP is not applicable, this could be 
> another option. 

You did not really answer any of my objections, nor did you consider
the alternative ideas which I offered. Would you care to address
those?

Thanks,
Richard
