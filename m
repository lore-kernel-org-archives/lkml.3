Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaINIYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:24:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57558 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaINIYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:24:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Sep 2014 10:24:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Nico Schottelius <nico-kernel-2014-08-14@schottelius.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Linux 3.16: O2 Micro MMC missing in lspci
Message-ID: <20140914102408.391efcaf@kant>
In-Reply-To: <20140814105351.GA3110@schottelius.org>
References: <20140814105351.GA3110@schottelius.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 14 Nico Schottelius wrote:
> Hello,
> 
> when booting into 3.16.0-2-ARCH I miss the following
> entry in lspci:
> 
> [12:50] gold:debug-sd-card-reader% diff 3.15/lspci 3.16/lspci 
> 17d16
> < 03:00.0 SD Host controller: O2 Micro, Inc. SD/MMC Card Reader
> Controller (rev 01)
> 
> This causes my system to be unable to mount/see the sd cards.
> My hardware is a Dell E7440 notebook.
> 
> I attached dmesg & lspci of both kernels.
> 
> Anyone an idea on what might be wrong?
> 
> The only related issues I found is
>     https://bugs.archlinux.org/task/26971
> 
> and that there was a change in the mmc area:
> 
>     https://lkml.org/lkml/2014/6/10/491
> 
> Cheers,
> 
> Nico
> 
> p.s.: Please cc on reply

Both the archlinux bug and the pull request very much appear to be
unrelated to your issue.  In your case, the MMC subsystem is not involved
since the PCI device of the SD controller is not exposed to the MMC
subsystem anymore, just like it is not exposed in lspci anymore.

I suggest as next steps:
  - Test whether the issue still exists in the newest kernel that you are
    able to install.  (v3.17-rc4 is current, v3.16.2 is the lastest on in
    the 3.16 branch.)
  - Post the dmesg output from a successful boot with 3.15 and from an
    unsuccessful boot with 3.16.

[added Cc: linux-pci]
-- 
Stefan Richter
-=====-====- =--= -===-
http://arcgraph.de/sr/
