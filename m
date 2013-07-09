Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3GIB0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 21:26:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50534 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3GIB0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 21:26:13 -0400
Date: Tue, 9 Jul 2013 03:26:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: joe.lawrence@stratus.com, myron.stowe@redhat.com, bhelgaas@google.com
Subject: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130709012611.GA22371@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

My thinkpad has rather high ping latencies... and perhaps it is due to
PCIE ASPM.

Its help text says:

CONFIG_PCIEASPM:

This enables OS control over PCI Express ASPM (Active State
Power Management) and Clock Power Management. ASPM supports
state L0/L0s/L1.
...
ASPM can be disabled or enabled at runtime via
/sys/module/pcie_aspm/parameters/policy

So I tried setting the parameter, but it seems to be broken :-(

root@amd:/data/pavel# cat /sys/module/pcie_aspm/parameters/policy
[default] performance powersave 
root@amd:/data/pavel# echo performance > /sys/module/pcie_aspm/parameters/policy
bash: echo: write error: Operation not permitted
root@amd:/data/pavel# echo -n performance > /sys/module/pcie_aspm/parameters/policy
bash: echo: write error: Operation not permitted
root@amd:/data/pavel# ls -al /sys/module/pcie_aspm/parameters/policy
-rw-r--r-- 1 root root 4096 Jul  9 03:16 /sys/module/pcie_aspm/parameters/policy
root@amd:/data/pavel# cat /sys/module/pcie_aspm/parameters/policy
[default] performance powersave 
root@amd:/data/pavel# echo powersave > /sys/module/pcie_aspm/parameters/policy
bash: echo: write error: Operation not permitted
root@amd:/data/pavel# echo -n powersave > /sys/module/pcie_aspm/parameters/policy
bash: echo: write error: Operation not permitted
root@amd:/data/pavel# echo -n default > /sys/module/pcie_aspm/parameters/policy
bash: echo: write error: Operation not permitted

Hmm:

CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set                                                     
# CONFIG_PCIEASPM_PERFORMANCE is not set                                                   

Should we avoid displaying options that can't be selected?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
