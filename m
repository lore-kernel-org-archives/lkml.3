Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaIZNHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:07:43 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38233 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaIZNHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD8401415409846D@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
	<CAL7Bo8HoYU1mbUbw-k0ufj7n8D=Z_hLtf268gKeyACcnZHH5rw@mail.gmail.com>
	<CD2CABCB2C0A0D4682C5F8AD8401415409846D@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Fri, 26 Sep 2014 14:07:40 +0100
Message-ID: <CAL7Bo8G_7cOYxbtPR=JDxE8VJShbzs2+2Y=F9OOABgFZr=m29A@mail.gmail.com>
Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Olaf Hering <olaf@aepfle.de>, Robo Bot <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> What happens when adjtimex is not present?
>> Is there no kernel space function for that?
>> Does this patch affect "not setting correct time on restore" or "not setting
>> correct time on  live migration" bug?
>>
>
> If adjtimex is not present, then the slew time part didn't take effect.
> There is a kernel space do_adjtmex, but it's only for sys call and not exposed to module. So I didn't use it in my patch.
> With this patch, it will step the clock if the time drift is larger than 1 seconds, so it can solve
> the issue your mentioned. And on the other hand, "setting correct time on restore" is already fixed
> in other patch, which is already in upstream.
>

AFAIK  CENTOS and RHEL stopped providing adjtimex for a while now (since V5?).
Even went as far as removing references from there man page for hwclock. in V6

On CENTOS 6.5

yum provides */adjtimex

Loaded plugins: fastestmirror, security
Loading mirror speeds from cached hostfile
 * base: centosc6.centos.org
 * extras: centosb5.centos.org
 * updates: centosb6.centos.org
No Matches found

So the end user will have to go searching the internet rpmfind or
something to install an unofficial package on an enterprise product.
So by default you will be stepping time on CENTOS/RHEL 6 and above:
with the result of an unstable clock.
