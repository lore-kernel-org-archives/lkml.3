Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaCFG0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:26:42 -0500
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:42303 "EHLO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbaCFG0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:26:40 -0500
X-Yahoo-Newman-Id: 778857.40576.bm@smtp215.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jdW2N.QVM1nX9i8YV2xngY4IgeVSfJrejcasDBYbk6ao5iv
 TvOphYELAR.Ln8FFm1BKj17._YKYJoxSIFDL0jfmnPj6r6dPQd2nRE0S6mUZ
 vhlFVBnh6Mev79EME8DqAQr7fhpCLe1bSjroYJv0qt.ufxBliZqeB5rfuJfs
 6No9FbI49fDTR6bmcOPqiL7RFAPCgBdkzeTAxQDaLSabu3IIDhpEEtwViTWm
 ipEyCpWGZeqL2X3ytxu05YCcIy933YhlYPDy3shx3zghDQkYIvs6Pfat56yL
 Th5SMGkWtgAhHMbBw7YbcoLWh4mojDAgXmoa4NIy9RofIQN8NNQzYEVcZwVM
 zC4okL1G7VnNL9Mq.RWzdZpXGOKvqQq6vnkywMeeBpI41RxCxSR3mqzokpVd
 syRVi2rpBUvsr2TVULVf.hQdAytB.LeyaunzM.8sQGjo5tMqgPoySHjFZ24H
 EARsp6gEdjXwqdNaU6.CnO7FaL6vVvkesS7BJD8D4W1xUTWf7uXjK8hjD_tI
 W7.xA5Z6sGe9TGNyUJQu_Bt7rf6ikF2iGCL3A5ussBH0Ed_QW4D0_WCPskPQ
 thSZFhKVsISFQlhhV2h6DH17Nm0XAMVZ.9OqdKtmjo3tLVj7bfJZNIHDcLYO
 YfzsQpQ--
X-Yahoo-SMTP: u9r3j8eswBBsV5z1r5v0bR9cjPS77vatbJK.6sw-
X-Rocket-Received: from [192.168.1.24] (draconicpenguin1@173.68.253.136 with plain [98.139.211.125])
        by smtp215.mail.bf1.yahoo.com with SMTP; 05 Mar 2014 22:20:45 -0800 PST
Message-ID: <531813B4.7060205@yahoo.com>
Date: Thu, 06 Mar 2014 01:20:36 -0500
From: Brian Wong <draconicpenguin1@yahoo.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux does not use more than the startup RAM under Hyper-V with dynamic
 memory enabled
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm new to LKML, so please don't be too hard on me :)

I'm running Gentoo Linux under Microsoft Client Hyper-V on Windows 8.1 
Pro, and I've noticed some odd behavior with respect to dynamic memory 
(aka memory ballooning). The system will never use more than the startup 
memory defined in the vitual machine's settings.

For example, if I set the startup memory to 512 MB, and enable dynamic 
memory with a minimum of 512 MB and a maximum of 8192 MB, the system 
will never allocate than 512 MB of physical memory, despite Hyper-V 
assigning more memory to the VM and the added memory being visible in 
the output of "free" and "htop". Attempting to use more memory causes 
the system to start paging to swap, rather than actually allocating the 
memory above the startup memory assigned to the VM.

The kernel is built with the full set of Hyper-V drivers, including the 
key "Microsoft Hyper-V Balloon Driver" as well as memory hot-add and 
hot-remove functionality. This is happening with both the Gentoo-patched 
3.10.32 kernel and the vanilla 3.12.5 kernel. The host machine has a 
total of 24 GB of memory.

For now, I am working around the issue by starting the VM with the 
startup memory set to the maximum and letting Hyper-V take the usused 
memory back when it is not in use. The VM will then get the extra memory 
when it needs it.

Have I encountered a bug in the Hyper-V balloon driver?

-- 
Brian Wong
http://www.fierydragonlord.com
