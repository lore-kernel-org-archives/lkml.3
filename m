Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab3IIA2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 20:28:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56542 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3IIA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 20:28:49 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522D163E.80106@roeck-us.net>
Date: Sun, 08 Sep 2013 17:28:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Shivaprasad G Bhat <sbhat@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>
Subject: powerpc allmodconfig build broken due to commit 15863ff3b (powerpc:
 Make chip-id information available to userspace)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

powerpc allmodconfig build on the latest upstream kernel results in:

ERROR: ".cpu_to_chip_id" [drivers/block/mtip32xx/mtip32xx.ko] undefined!

This is due to commit 15863ff3b (powerpc: Make chip-id information available to userspace).
Not surprising, as cpu_to_chip_id() is not exported.

Reverting this commit fixes the problem. Any good idea how to fix it for real ?

Guenter
