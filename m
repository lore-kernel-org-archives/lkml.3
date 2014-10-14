Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbaJNOOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:14:31 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38735 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaJNOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <20141014132551.GB5994@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
	<20141014115412.GC4019@localhost.localdomain>
	<CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
	<20141014132551.GB5994@localhost.localdomain>
Date: Tue, 14 Oct 2014 15:14:21 +0100
Message-ID: <CAL7Bo8EHOgBFtE87ecC9PSwUy2=M5Q31ka6BX2Eut-eqXSbang@mail.gmail.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Shao <huishao@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even with networking I think there are other senarios where this would
be useful such as no access to an NTP server  due to firewall rules or
no internal NTP or simply an admin without much knowledge of NTP.

HyperV host very likely has good time from AD and it would be good if
the Linux VM just synced its time from the host after a vanilla
install  (just like windows VMs).
That would require no configuration and probably save a ton of support traffic.
However this patch requires a module parameter which really negates
the zero configuration argument.
Also please don't make this the default until the timesync component
is more comprehensive and provides a stable time of similar quality to
NTP.
VMware has put a lot of effort into host -> guest timesync so I think
there is a case for some form of host based time sync on HyperV.
