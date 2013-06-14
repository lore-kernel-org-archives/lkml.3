Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3FNLrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 07:47:08 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51871 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3FNLrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 07:47:06 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Regression in RCU subsystem in latest mainline kernel
Date: Fri, 14 Jun 2013 13:47 +0200
Message-ID: <1626500.7WAVXjfS9F@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the current mainline kernel from git reproducibly hangs on my Freescale 
PowerPC P5020DS development system. Most of the time the hang occurs during 
boot (kernel just stops booting, system hangs), sometimes shortly after 
booting (system hangs, no message). Very often booting stops at the 
initialization of the Intel PRO 1000 PCIe network device (e1000e).

I used git bisect and arrived at this commit:

016a8d5be6ddcc72ef0432d82d9f6fa34f61b907
rcu: Don't call wakeup() with rcu_node structure ->lock held

With versions before that commit the system runs normally.

   Rojhalat


