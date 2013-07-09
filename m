Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3GIJtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:49:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34989 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:49:08 -0400
Date: Tue, 9 Jul 2013 11:49:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, joe.lawrence@stratus.com,
        myron.stowe@redhat.com, bhelgaas@google.com
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130709094906.GA3870@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709041321.GA30555@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-07-08 21:13:21, Greg KH wrote:
> On Tue, Jul 09, 2013 at 03:26:11AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > My thinkpad has rather high ping latencies... and perhaps it is due to
> > PCIE ASPM.
> 
> Why would that be the problem?  The odds that the PCIE bus is the issue
> seems strange to me.

Aha: I guess that's why the file is not writable:

pavel@amd:~$ dmesg | grep -i aspm 
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
e1000e 0000:02:00.0: Disabling ASPM L0s L1
pavel@amd:~$ cat /sys/module/pcie_aspm/parameters/policy
[default] performance powersave 
pavel@amd:~$ 
root@amd:~# echo -n performance >
/sys/module/pcie_aspm/parameters/policy
-su: echo: write error: Operation not permitted
root@amd:~# 

But:
1) it should not list unavailable options

2) operation not permitted seems like wrong error code for
operation not supported.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
