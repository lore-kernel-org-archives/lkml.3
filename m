Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbaJNOdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:33:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34878 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121AbaJNOdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:33:52 -0400
Date: Tue, 14 Oct 2014 16:33:46 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
Cc: Thomas Shao <huishao@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014143346.GC6469@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141014132551.GB5994@localhost.localdomain>
 <CAL7Bo8EHOgBFtE87ecC9PSwUy2=M5Q31ka6BX2Eut-eqXSbang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL7Bo8EHOgBFtE87ecC9PSwUy2=M5Q31ka6BX2Eut-eqXSbang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:14:21PM +0100, Mike Surcouf wrote:
> Even with networking I think there are other senarios where this would
> be useful such as no access to an NTP server  due to firewall rules or
> no internal NTP or simply an admin without much knowledge of NTP.

Perhaps, but ...

> HyperV host very likely has good time from AD and it would be good if
> the Linux VM just synced its time from the host after a vanilla
> install  (just like windows VMs).

Just cause windows does it, doesn't make it a good idea.

> That would require no configuration and probably save a ton of support traffic.
> However this patch requires a module parameter which really negates
> the zero configuration argument.
> Also please don't make this the default until the timesync component
> is more comprehensive and provides a stable time of similar quality to
> NTP.

We really don't want to go there.

> VMware has put a lot of effort into host -> guest timesync so I think
> there is a case for some form of host based time sync on HyperV.

Again, that is fine for VMware, but it might not be the best way.

IMHO, you should let the guest steer its own clock. That gives the end
user the most flexibility. Just provide the offset information, and
let a dedicated service (like ntpd or linuxptp's phc2sys) do the rest.

Thanks,
Richard
