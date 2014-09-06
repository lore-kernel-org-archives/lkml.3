Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaIFS3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 14:29:24 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45537 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751543AbaIFS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 14:29:22 -0400
Date: Sat, 6 Sep 2014 19:29:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jurriaan <jurriaan@onderneming10.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ARM kirkwood: 1 Gb memory 25% unusable due to vmalloc region
	overlap
Message-ID: <20140906182916.GA12361@n2100.arm.linux.org.uk>
References: <20140906173207.GA1046@qnap.onderneming10.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906173207.GA1046@qnap.onderneming10.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 07:32:07PM +0200, Jurriaan wrote:
> I updated my Qnap TS-212 with 256 Mb memory to a new TS-221 with 1 Gb
> memory.
> 
> On booting, I see that a large chunk of that new memory is not used by
> linux:
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.14-2-kirkwood (debian-kernel@lists.debian.org) (gcc version 4.8.3 (Debian 4.8.3-7) ) #1 Debian 3.14.15-2 (2014-08-09)
> [    0.000000] CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053977
> [    0.000000] CPU: VIVT data cache, VIVT instruction cache
> [    0.000000] Machine: QNAP TS-119/TS-219
> [    0.000000] Ignoring unrecognised tag 0x41000403
> [    0.000000] Truncating RAM at 20000000-3fffffff to -2f7fffff (vmalloc region overlap).
> 
> Whoops!

You can either enable highmem (which has been available on ARM for
ages now, there's little excuse not to use it) or reduce the available
userspace virtual memory by enabling VMSPLIT_2G.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
