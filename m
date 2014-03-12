Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaCLNMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:12:23 -0400
Received: from fallback8.mail.ru ([94.100.176.136]:50182 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaCLNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:12:21 -0400
Message-ID: <53205BEB.4090908@mail.ru>
Date: Wed, 12 Mar 2014 17:06:51 +0400
From: Alexander Varnin <fenixk19@mail.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: s3c2443 hangs on msleep on resume from suspend
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I'm developing on Samsung s3c2443 CPU and now my aim is to make suspend
mode working properly. My kernel version is 3.6. Everything was OK,
however Linux hanged on resume, if usb ohci driver was loaded. My
investigation showed, that it hangs on msleep function, that is getting
called in ohci_run() function in drivers/usb/host/ohci-hcd.c file. Exact
line of code is [1]. I found on the web, that there was [2] similar
problem on s3c2410. The reason of hang is that msleep locks the only
working thread in system, and nobody can unlock it. The simple
workaround is to replace msleep with mdelay. But the usage of msleep is
in platform-independent usb-ohci code. That means, that other platforms
somehow bypass this problem, and work with msleep correctly. But I will
prefer to fix it in platform-depended, than to make workaround in common
code.

What bugs in platform-depended code could lead to such problem?

I suggest, that there is some problem with sequence of resume actions,
and usb resume happens much earlier, than it have to. But where exactly
should I search for the problem?

Thanks,
Alexander.

[1]
http://lxr.free-electrons.com/source/drivers/usb/host/ohci-hcd.c?v=3.6;a=arm#L621
[2] http://osdir.com/ml/handhelds.openmoko.kernel/2008-05/msg00168.html

