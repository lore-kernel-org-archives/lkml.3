Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3GBI6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:58:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35288 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab3GBI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:58:38 -0400
Date: Tue, 2 Jul 2013 09:58:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joseph Lo <josephl@nvidia.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 07/32] arm: delete __cpuinit/__CPUINIT usage from all
	ARM users
Message-ID: <20130702085818.GD24642@n2100.arm.linux.org.uk>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com> <1372102237-8757-8-git-send-email-paul.gortmaker@windriver.com> <1372755120.2874.18.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372755120.2874.18.camel@jlo-ubuntu-64.nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 04:52:00PM +0800, Joseph Lo wrote:
> I just tested this series on Tegra platform. It looks broken CPU hotplug
> function for Tegra at least. The CPU can't plug-in after unplugging. And
> the system resume function also not working when "enable_nonboot_cpus".
> 
> Both of the issue cause system hang up. Are we missing something for
> __cpuinit removal work?

Check that any assembly code you're using where the __CPUINIT* marker has
been removed is not preceded by an __INIT or similar.   This code needs
to end up in the normal .text, .data or .bss sections now.
