Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaLBLRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:17:19 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:45124 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbaLBLRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:17:16 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC 1/2] i2c: omap: fix buffer overruns during RX/TX data processing
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141201195841.GD2817@atomide.com>
Date: Tue, 2 Dec 2014 14:17:13 +0300
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B3F4FEFF-2333-473D-8A35-7D4EF1C44D90@gmail.com>
References: <1417294803-14729-1-git-send-email-al.kochet@gmail.com> <1417294803-14729-2-git-send-email-al.kochet@gmail.com> <20141201195841.GD2817@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


01 дек. 2014 г., в 22:58, Tony Lindgren <tony@atomide.com> написал(а):

> I think this is a different issue than what I'm seeing.

Hello, Tony!

Thank you for testing!

Could check i2c-omap.c from commit ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4.
As all my changes comes after it[1]. So I can understand was the problem before my work.

I there was no problems, then try with my first commit:
27caca9d2e01c92b26d0690f065aad093fea01c7

The problems you talk about is this?
[    9.675994] omap_i2c 48072000.i2c: controller timed out
[   10.704010] omap_i2c 48072000.i2c: controller timed out
[   11.734069] omap_i2c 48072000.i2c: controller timed out
root@omap2430sdp:/# [   12.823638] omap_i2c 48072000.i2c: controller timed out

And how it is possible to switch from ti,omap2430-i2c to ti,omap2420-i2c? They are so different IP, from
the driver point of view. They have different data bus width.

Alexander.

[1]
alexander@ubuntu:busses$ git log --pretty=oneline --reverse ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4^..HEAD -- i2c-omap.c 
ca1f8da9ac5ce6e63d8f6933f83fabc1f3f961f4 i2c: remove FSF address
27caca9d2e01c92b26d0690f065aad093fea01c7 i2c: omap: fix NACK and Arbitration Lost irq handling
854a59425a0b9600ee974b113aae081c873163f6 i2c: omap: cleanup register definitions
903c3859f77f9b0aace551da03267ef7a211dbc4 i2c: omap: implement workaround for handling invalid BB-bit values
80cc361f14e8fa97119afa3324c2c913915e7252 i2c: omap: don't reset controller if Arbitration Lost detected
39370ab406933efdedb425910f0a36c16667c45f i2c: omap: add notes related to i2c multimaster mode
ccfc866356674cb3a61829d239c685af6e85f197 i2c: omap: fix i207 errata handling
7d168dc7ed384e50bb7bff4920b73550fd2e9fcb Merge branch 'i2c/for-3.19' into i2c/for-next
2f769d173f0e6a2e85d75fe396f18f794fc4a615 omap: i2c: don't check bus state IP rev3.3 and earlier
2b6f66d87b44aaf1f34f071e6f6430c3ccaa8812 i2c: omap: fix buffer overruns during RX/TX data processing
30c52545106785405856c7e7e40b683b79c8084a i2c: omap: show that the reason of system lockup is an unhandled ISR event


