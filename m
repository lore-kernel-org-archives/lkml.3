Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaBUUSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:18:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48474 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaBUUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:18:53 -0500
Message-ID: <5307B4AB.7020709@infradead.org>
Date: Fri, 21 Feb 2014 12:18:51 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>, linux-kernel@vger.kernel.org
Subject: Re: progress, marching to the rear
References: <201402202313.11871.gheskett@wdtv.com>
In-Reply-To: <201402202313.11871.gheskett@wdtv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 08:13 PM, Gene Heskett wrote:
> I finally found a keyboard I can use when the boots fails to the
> initramfs: prompt.  ps2 plug on it.
> 
> From the messages it leaves on screen, it is NOT finding the drive plugged 
> into the mobo SATA1 connector when I try to boot to a 3.13.1-2-3 kernel.

If the drive is just slow to spin up, you could try another kernel command line
option:
	rootdelay=30
or some other number of seconds to delay before attempting to mount the root fs.

> So just to verify I am looking in the right place in the /sys directory, I 
> believe I was in drivers/pci/sata_nv when I took the pix now up on my web 
> page.  
> 
> This is an ASUS M2N SLI Deluxe mobo, 8 Gigs of ram, phenom 9550 running 
> slow at 2.1 Ghz.  This needs the sata_nv module to work with this hardware.
> 
> There are 4 drives in this box, and they are all working just fine when 
> booted to 3.12.9, but that pix I just posted to my web page in the link 
> below, in the Genes-os9-stf/LCNC link looks like there are only 3, and the 
> first one has been enumerated to pci 5:0. Then 5:1 and 5:2 if I am reading 
> that right.  But that same location in the 3.12.9 boot also only shows 3 
> "devices" so obviously I don't know what I am doing.  Again...

on a working good boot, what are the four drives listed as?

> So, when all I have is the initramfs: prompt, where in the /sys tree can I 
> verify that all 4 drives are present and awake?

I see my single drive listed in /sys/block and /sys/dev/block.


Have you already tried something like taking the working 3.12.9 .config file and
just modifying it a few bits at a time until it either fails or you get what you
want?

-- 
~Randy
