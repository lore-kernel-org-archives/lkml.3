Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaIZJYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:24:09 -0400
Received: from mail-ig0-f193.google.com ([209.85.213.193]:56622 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaIZJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:24:06 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD8401415409741D@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
	<20140923075610.GA10933@aepfle.de>
	<20140925060745.GA9450@sucs.org>
	<CD2CABCB2C0A0D4682C5F8AD84014154094643@HKXPRD3002MB006.064d.mgd.msft.net>
	<20140925132055.GA13108@sucs.org>
	<CD2CABCB2C0A0D4682C5F8AD8401415409741D@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Fri, 26 Sep 2014 10:24:05 +0100
Message-ID: <CAL7Bo8EP8he+OycqAnnNOD+W9eZ=qYfUNXFJ5zffUHq_0GUxYQ@mail.gmail.com>
Subject: Re: Time keeps on slipping... on Hyper-V
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We still recommend user to configure NTP in the guest VM. With the new time sync feature in this patch,
> you could have one more option to enable the guest-host sync, if the NTP didn't work in the environment.
> For example the guest VM didn't have network connection.

Microsoft used to use host time-samples in their older drivers but
this was dropped (when I don't know).
Now we must use NTP to correct hyperv_clocksource which suffers from
the usual problems associated with virtual environment  cpu loading.

Host time-samples in conjunction with an effective clock stability
algorithm with slews rather than steps should be the default.
NTP is a workaround and should not be the primary solution.

I have seen a lots of posts for RHEL CENTOS  Linux that have a
FAST.hyper_clocksource confirmed by myself on CENTOS 6.5 and 7.0
(also confirmed by Olaf on SLES).

If this patch steps the clock once in a while without any form of
slewing then it has the potential to break things as files and logs
travel BACK in time.

Apologies Thomas could you send me the patch via email as lkml.org
does not have it in the archives.

Regards Mike
