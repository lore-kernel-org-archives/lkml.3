Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbbAHMOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:14:20 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52212 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754103AbbAHMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:14:19 -0500
Date: Thu, 8 Jan 2015 12:14:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Abhijit Ray Chaudhury <abhijit.ray.chaudhury@gmail.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Question regarding Linux Bringup in ARMA9 platform
Message-ID: <20150108121410.GT12302@n2100.arm.linux.org.uk>
References: <CAACKNgW6S4fFvsczgMODb6NdH+r_H62VAHG+-3uWcK7RFHUUdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACKNgW6S4fFvsczgMODb6NdH+r_H62VAHG+-3uWcK7RFHUUdw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:42:29PM +0530, Abhijit Ray Chaudhury wrote:
> Uncompressing Linux... done, booting the kernel.
> Booting Linux on physical CPU 0
> Linux version 3.6.0-uc0  (gcc version 4.7.1 (crosstool-NG 1.16.0) ) #7 PREEMPT Tue Jan 6 12:29:13 IST 2015
> CPU: ARMv7 Processor [413fc090] revision 0 (ARMv7), cr=10c53c7f

You're using a very old kernel, which leaves the alignment fault
enabled,r ather than relying on the CPU to fix up alignment faults
itself.  Newer kernels should have this fixed.  Or apply

"ARM: 7150/1: Allow kernel unaligned accesses on ARMv6+ processors"

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
