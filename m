Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaIEPm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:42:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33137 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751233AbaIEPmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:42:55 -0400
Date: Fri, 5 Sep 2014 12:41:40 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: klightspeed@killerwolves.net
Cc: linux-arm-kernel@lists.infradead.org, Arnaud Ebalard <arno@natisbad.org>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] ARM: MVEBU: Netgear RN102: Use Hardware BCH ECC
Message-ID: <20140905154140.GA1377@arch.hh.imgtec.org>
References: <1409898233-9273-1-git-send-email-klightspeed@killerwolves.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409898233-9273-1-git-send-email-klightspeed@killerwolves.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Fixing Cc list: dropping devicetree guys, and adding Brian and MTD instead)

On 05 Sep 04:23 PM, klightspeed@killerwolves.net wrote:
> The bootloader on the Netgear ReadyNAS RN102 uses Hardware BCH ECC
> (strength = 4), while the pxa3xx NAND driver by default uses 
> Hamming ECC (strength = 1).
> 

Hm, I guess the device (Hynix H27U1G8F2BTR) does not support ONFI,
and the kernel is just taking the legacy ECC. The flash specs makes no
mention to ONFI, so probably no ONFI here.

> This patch changes the ECC mode on these machines to match that
> of the bootloader and of the stock firmware, so that for example
> updating the kernel is possible without requiring a serial
> connection.
> 
> This patch depends on commit 5b3e507 (mtd: nand: pxa3xx: Use ECC
> strength and step size devicetree binding)
> 
> Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>

Looks good to me, since Arnaud reports this is the correct ECC scheme:
http://natisbad.org/NAS2/index.html#hw-nand

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Thanks for the fix,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
