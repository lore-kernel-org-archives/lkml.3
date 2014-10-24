Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaJXOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:25:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42397 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbaJXOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:25:24 -0400
Date: Fri, 24 Oct 2014 15:24:35 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Serban Constantinescu <Serban.Constantinescu@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ghackmann@google.com" <ghackmann@google.com>,
        "ijc@hellion.org.uk" <ijc@hellion.org.uk>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Message-ID: <20141024142435.GK24265@leverpostej>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
 <20141024141936.GS27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024141936.GS27405@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:19:36PM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 24, 2014 at 02:56:39PM +0100, Mark Rutland wrote:
> > Currently, the arm64 /proc/cpuinfo format differs from that of arm, in a
> > manner which prevents some otherwise portable applications from
> > functioning as expected. Specifically, the "Features" line describes the
> > 64-bit hwcaps exclusive of the 32-bit hwcaps, which causes issues for
> > certain applications which attempt to parse /proc/cpuinfo to detect
> > features rather than directly using the hwcaps exposed via auxval.
> 
> Like it or not, but every file in procfs is a userspace API, and can
> be parsed by any program.  If we change a procfs file and a userspace
> program then stops working, that's our fault, and our problem to fix
> (by restoring the information published there in a manner which
> userspace can parse.)
> 
> So, as you've found some programs which rely on this, ARM64 really does
> need to be compatible with ARM32 in this respect.

I agree, hence this RFC.

The key question is how we fix the arm64 /proc/cpuinfo format to make
those programs function, without potentially breaking other
applications.

> It's unfortunate that people have decided that parsing the ELF HWCAPs
> from /proc/cpuinfo is an acceptable way to go, rather than using the
> binary information passed, but procfs is a much more visible source
> of information than some binary interface which you need to read man
> pages to find.
> 
> That's the danger of publishing information in either procfs or sysfs.
> Once published, it becomes part of the userspace API, and it can become
> hard to remove it.  This is why we should /always/ think very carefully
> about what we expose through these filesystems.

Yes. We made a mistake here with the arm64 format. Hopefully there's a
way by which we can keep applications happy.

For future architectures, it's probably worth putting stronger
guidelines in place to prevent precisely the issues we've hit here.

Mark.
