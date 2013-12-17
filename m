Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3LQGjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:39:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63681 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751835Ab3LQGjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:39:47 -0500
X-Virus-Scanner: SBL::Mail::ClamAV on Strong Branch server: orion.intree.net
	[ClamAV 0.97.3/18249/Tue Dec 17 00:41:49 2013]
Message-ID: <52AFF1B1.4000303@intellitree.com>
Date: Tue, 17 Dec 2013 01:39:45 -0500
From: Michael Conrad <mconrad@intellitree.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How do I enumerate firmware used by compiled-in drivers?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I am trying to maintain an initrd for a homebrew Linux distro. I'm 
having a problem where kernel modules are gradually shifting from 
linux/firmware to /lib/firmware, which breaks my initrd (which currently 
uses CONFIG_FIRMWARE_IN_KERNEL).  I am looking for a way to extract a 
list of needed firmware files from my compiled kernel so that I can 
include them in my initrd.  I want to automate this so that I don't have 
to fight it on every kernel upgrade.  A helpful fellow on freenode 
#kernel pointed out that modinfo contains a list of firmware names, but 
didn't know any way to find that information for compiled-in drivers.  
Is there any way I can do this?

More context:

I have an initrd, so I'm ok with the idea of switching from 
firmware-in-kernel to /lib/firmware.  However /lib/firmware is 57 MB and 
contains many firmware files which aren't even used by Linux 3.10.17 or 
by my configuration.  I want to include only the ones that the kernel 
might try to load.

I want to support most popular network and storage chipsets, plus a few 
specific less popular ones, so I have lots of drivers selected (some 
modules, some compiled-in) and I don't want to be surprised when a 
driver (like bnx2) decides to switch from an in-kernel firmware to a 
lib/firmware file.  I want my kernel-build script to search for and 
include these AUTOMATICALLY, because there are too many to inspect them 
by hand each time I upgrade.

Does anyone have advice for this?

Thanks in advance.
-Mike
