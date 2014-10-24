Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaJXOTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:19:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43654 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907AbaJXOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:19:49 -0400
Date: Fri, 24 Oct 2014 15:19:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, cross-distro@lists.linaro.org,
        catalin.marinas@arm.com, serban.constantinescu@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        ghackmann@google.com, ijc@hellion.org.uk, linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Message-ID: <20141024141936.GS27405@n2100.arm.linux.org.uk>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 02:56:39PM +0100, Mark Rutland wrote:
> Currently, the arm64 /proc/cpuinfo format differs from that of arm, in a
> manner which prevents some otherwise portable applications from
> functioning as expected. Specifically, the "Features" line describes the
> 64-bit hwcaps exclusive of the 32-bit hwcaps, which causes issues for
> certain applications which attempt to parse /proc/cpuinfo to detect
> features rather than directly using the hwcaps exposed via auxval.

Like it or not, but every file in procfs is a userspace API, and can
be parsed by any program.  If we change a procfs file and a userspace
program then stops working, that's our fault, and our problem to fix
(by restoring the information published there in a manner which
userspace can parse.)

So, as you've found some programs which rely on this, ARM64 really does
need to be compatible with ARM32 in this respect.

It's unfortunate that people have decided that parsing the ELF HWCAPs
from /proc/cpuinfo is an acceptable way to go, rather than using the
binary information passed, but procfs is a much more visible source
of information than some binary interface which you need to read man
pages to find.

That's the danger of publishing information in either procfs or sysfs.
Once published, it becomes part of the userspace API, and it can become
hard to remove it.  This is why we should /always/ think very carefully
about what we expose through these filesystems.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
