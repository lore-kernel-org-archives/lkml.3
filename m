Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab3FLBcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:32:15 -0400
Received: from web100019.mail.kks.yahoo.co.jp ([114.111.98.193]:47030 "HELO
	web100019.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757608Ab3FLBcO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:32:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20110701; d=yahoo.co.jp;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eEuY7WtOGcrTr9ypFDhMiPbKovRwsKk1ZuIlTxsLm9V5wuar5Y5QOg26LRjbE2cCbUJ6hXfSAO+Boaaw1DOC+a7JcorInSA9I6lJ0VTsbVN5xHqG8ag1MX1hHIbMxcdHzP8zOnpEmqGngCoGq2whQnCPzWg5RzRQ0MvV04j9z3E=;
Message-ID: <749753.81252.qm@web100019.mail.kks.yahoo.co.jp>
X-YMail-OSG: 1qc8Vn8VM1nxDmi44VramGhzLloy9yPiMMHwwgsGZA.kqoIkbXHSCwEcki3mAQGaHKflRQZgpG7EZUkEe4dgNejovKFUs551Wqw5lthzLwl3KDc5tPqCvDf5lgwEGB_09OOAi0Ehdh82rTMXp4nxKhql5tElWNJhz8XjUxPPsteyMT5Tf99zmiL3n0grxV9rxPkMiAXtO_gp9rqhYF2Vf8ornYf_hpILY4dAgx33c6IfkfNGYnM4KYUvdO7WAGN7usvCnlunvVX9Oe5bErWPQ.MSqUNvRH_wRRFWs.e.F_HJajaVRmsfu7ONgxfJAmiEmIyYzNy6xTfwCyXA12Ml_6gBgmBrwRbU8zzUxKImmsfMZFY8kkrCGg--
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.8.111_45
Date: Wed, 12 Jun 2013 10:25:32 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: USB 3.0 failure and possible regression in kernel 3.8.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernels somewhere around 2.6.35 could handle USB 3.0 at random sometimes,
but kernel 3.8.0 fails consistently.  I know I should try to bisect this,
but I don't have time and the randomness of the older kernel doesn't help.

lspci:
0d:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0 Host Controller
 [1033:0194] (rev 04)
         Kernel driver in use: xhci_hcd

lsusb:
Bus 007 Device 002: ID 152d:0539 JMicron Technology Corp. / JMicron USA Technology Corp.

dmesg:
[  458.857081] usb 6-1: new high-speed USB device number 2 using xhci_hcd
[  463.857085] xhci_hcd 0000:0d:00.0: Timeout while waiting for address device command
[  464.728073] xhci_hcd 0000:0d:00.0: Stopped the command ring failed, maybe the host is dead
[  464.728073] xhci_hcd 0000:0d:00.0: Host not halted after 16000 microseconds.
[  464.728073] xhci_hcd 0000:0d:00.0: Abort command ring failed
[  479.976010] [sched_delayed] sched: RT throttling activated
[  479.987230] xhci_hcd 0000:0d:00.0: HC died; cleaning up
