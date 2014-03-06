Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaCFG0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:26:10 -0500
Received: from nm21.bullet.mail.bf1.yahoo.com ([98.139.212.180]:37580 "EHLO
	nm21.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbaCFG0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:26:08 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 01:26:08 EST
X-Yahoo-Newman-Id: 729361.36378.bm@smtp108.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: lTxVjUwVM1lfCJB3CqrTTo5jjLNtOJZnWX1YtGc4_Jie7Ev
 vLSs7yHF8fzv8tQ_YKh4moRuyUskh5TSVuJJJWUakUm4ghKQfrYqr8D1LMZA
 g7cn58vmusSXoHUpXU8wHVJLIkdXsm4RtFF9t1nTAJNxcJHkoUCMjuKH6Rk2
 5BmduKlEW4w9ZmYxfIcT7pO7wB_XhW0Lt4r9CdJ1dDSqTZj56Rmk64lZNCn_
 kfhIiIXflglc.RFIQoM6Ja7cJgv1ZBdjLwaRRkp1sbXj6BS_.CdWz4HRjLg3
 .9a34S0sKF2sSRRlW0X5IRjB7rnkmpjWsPOXD6M7kbqYwcQpdl3sFW14_2p0
 ie8GnN_TwmtVN5_3NMK3tSG3Ngs6gptdsw._7_vt1qd98X0fbuSBIOtH9NmM
 hfjo5cSLEXihpnyu3DbBW6gFCtBRceeNXYGztsdg1XaUl7s0dHdGxY2W1rZ8
 WllfCZ81xIhrpRRmWTJePqqMOqDeaywQv.KnLV1KOEGL0Y5OtGwNLxaWMIMw
 y3_uDFYY6jz8q0Ms8q_A4KljZKuAubpTeYkZERbIf4klOP9mgj3pBepBDq5X
 aLhZz3ECPeyG.di1TPeav5HVO5MWXCPLLYLGKwbagjVMocaC4y2n.a2X0CA6
 9FLdqAA--
X-Yahoo-SMTP: u9r3j8eswBBsV5z1r5v0bR9cjPS77vatbJK.6sw-
X-Rocket-Received: from [192.168.1.24] (draconicpenguin1@173.68.253.136 with plain [98.139.211.125])
        by smtp108.mail.bf1.yahoo.com with SMTP; 05 Mar 2014 22:24:18 -0800 PST
Message-ID: <53181489.6040000@yahoo.com>
Date: Thu, 06 Mar 2014 01:24:09 -0500
From: Brian Wong <draconicpenguin1@yahoo.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux does not use more than the startup RAM under Hyper-V with
 dynamic memory enabled
References: <531813B4.7060205@yahoo.com>
In-Reply-To: <531813B4.7060205@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2014 1:20 AM, Brian Wong wrote:
> I'm new to LKML, so please don't be too hard on me :)
>
> I'm running Gentoo Linux under Microsoft Client Hyper-V on Windows 8.1
> Pro, and I've noticed some odd behavior with respect to dynamic memory
> (aka memory ballooning). The system will never use more than the startup
> memory defined in the vitual machine's settings.
>
> For example, if I set the startup memory to 512 MB, and enable dynamic
> memory with a minimum of 512 MB and a maximum of 8192 MB, the system
> will never allocate than 512 MB of physical memory, despite Hyper-V
> assigning more memory to the VM and the added memory being visible in
> the output of "free" and "htop". Attempting to use more memory causes
> the system to start paging to swap, rather than actually allocating the
> memory above the startup memory assigned to the VM.
>
> The kernel is built with the full set of Hyper-V drivers, including the
> key "Microsoft Hyper-V Balloon Driver" as well as memory hot-add and
> hot-remove functionality. This is happening with both the Gentoo-patched
> 3.10.32 kernel and the vanilla 3.12.5 kernel. The host machine has a
> total of 24 GB of memory.
>
> For now, I am working around the issue by starting the VM with the
> startup memory set to the maximum and letting Hyper-V take the usused
> memory back when it is not in use. The VM will then get the extra memory
> when it needs it.
>
> Have I encountered a bug in the Hyper-V balloon driver?
>

Just a correction: the vanilla kernel version is 3.13.5, not 3.12.5. 
Sorry for any confusion.

-- 
Brian Wong
http://www.fierydragonlord.com
