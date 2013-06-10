Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3FJXXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:23:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41550 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3FJXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:23:00 -0400
Date: Tue, 11 Jun 2013 00:22:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: vexpress: Make the driver optional for arm and
	arm64
Message-ID: <20130610232249.GH18614@n2100.arm.linux.org.uk>
References: <1370876955-26050-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370876955-26050-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 04:09:15PM +0100, Pawel Moll wrote:
> The driver can be used on either arm or arm64 platforms, but
> the latter doesn't have any platform-specific configuration
> options, so it must be possible to manually enable the driver.
> 
> As the gpiolib is optional for arm64 arch, the gpio/led code
> must be compiled conditionally.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  drivers/mfd/Kconfig           |  3 ++-
>  drivers/mfd/vexpress-sysreg.c | 10 ++++++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> Hi Samuel,
> 
> Could you please queue this small change for 3.11?

Please use #ifdef rather than a single #if defined().  #if defined()
on its own is unnecessarily ugly.

