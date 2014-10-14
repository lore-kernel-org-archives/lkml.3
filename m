Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaJNNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:25:59 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:57493 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaJNNZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:25:57 -0400
Date: Tue, 14 Oct 2014 15:25:51 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014132551.GB5994@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:04:35PM +0000, Thomas Shao wrote:
> > I really don't see the need for this. We have NTP. If the guests want to, they
> > may use it. Otherwise, they have a free running clock, just like real machines.
> > 
> Sometimes the user can't setup NTP. For example the guest OS didn't have network
> connection. And in some cases, they may want the guest time sync with host. 
> With the existing hyper-v time source, the system clock will has around 1.5 second
> time drift per day. If the workload in the host is heavy, the number could be larger.
> So this feature is really useful for some scenarios.

Any real machine without networking (and without GPS etc) will
drift. That is just life, tough as it is. Why should we treat these
guests any differently than real machines?

Furthermore, without networking you really don't have a compelling
need for correct absolute time in the first place.

Thanks,
Richard
