Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3G3S1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:27:12 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:53206 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3G3S1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:27:08 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2013 14:27:08 EDT
Date: Tue, 30 Jul 2013 14:17:40 -0400 (EDT)
From: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>, m-watkins@ti.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        davinci-linux-open-source@linux.davincidsp.com,
        kernel <kernel@savoirfairelinux.com>
Message-ID: <108709052.651756.1375208260748.JavaMail.root@mail>
In-Reply-To: <736128401.605095.1375206899203.JavaMail.root@mail>
Subject: PRUSS MFD staging driver: status update
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC28 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg.

I am interested in continuing the work of Subhasish Ghosh regarding
TI PRUSS drivers integration on the kernel side. The last LKML reply
I'm aware of is yours, 2 years ago, here:
<https://lkml.org/lkml/2011/7/5/548>, and then there was silence.

Just a quick reminder: PRUSS (Programmable Realtime Unit SubSystem) is a
subsystem on various TI DSPs/SoCs that contains two independent RISC
cores. Each PRU has its own data/instruction RAM. See
<http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem>.

My main objective is to eventually have a soft UART (which relies on a
PRU) integrated into the mainline. Since this would depend on common
routines shared by other drivers using PRUSS (enable/disable the PRUSS
clock, load a firmware, start/stop a specific PRU, configure interrupts,
etc.), common exported PRUSS functions need to be available.

I believe that's what Subhasish Ghosh was trying to do with his PRUSS
MFD staging driver.

Now, what is the status of this? Would you still accept a valid patch
for this "MFD" driver in staging? My idea, however, is more about a set
of common functions that could be used by other "real" drivers. This
means nothing exported to user space, no sysfs, etc., since only kernel
drivers would use them (I don't intend user space drivers to rely on
this; they already have drivers/uio/uio_pruss for this).

Also, at least today, PRUSS is not only part of the DA850 devices, but
also included into OMAP-L1x8/OMAP-L1x7, C674n, AM18xx/AM17XX and
AM335x devices, so I wouldn't mention "DA8XX" in the Kconfig.

Please Cc me in any answer/comment regarding this message.

Thank you if you have any time to look into this,
Phil
