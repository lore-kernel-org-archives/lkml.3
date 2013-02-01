Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3BACXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:23:12 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:27674 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3BACXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:23:11 -0500
Message-ID: <510B270C.5000603@tilera.com>
Date: Thu, 31 Jan 2013 21:23:08 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kbuild test robot <fengguang.wu@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt' undeclared
References: <510aa746.fVU8ZdQ2hys/RwjS%fengguang.wu@intel.com> <20130131231433.GM6824@mtj.dyndns.org> <510B1051.5010200@tilera.com> <20130201005225.GQ6824@mtj.dyndns.org>
In-Reply-To: <20130201005225.GQ6824@mtj.dyndns.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/2013 7:52 PM, Tejun Heo wrote:
> Hello, Chris.
>
> On Thu, Jan 31, 2013 at 07:46:09PM -0500, Chris Metcalf wrote:
>> That seems reasonable to me, but I'm happy to experiment with
>> including Kconfig.freezer from the arch/tile/Kconfig if that feels
>> like a better solution.
> AFAICS, there's nothing arch specific about freezer and cgroup_freezer
> could be useful even without powersaving, so maybe give it a shot?

It builds with the following change.  Look good to you?

commit 8c9632acfaea4cf6ae064d8291eea989b0df2bcf
Author: Chris Metcalf <cmetcalf@tilera.com>
Date:   Thu Jan 31 21:21:36 2013 -0500

    tile: include kernel/Kconfig.freezer in tile Kconfig

    Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1adb853..d9072ba 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -142,6 +142,8 @@ config ARCH_DEFCONFIG

 source "init/Kconfig"

+source "kernel/Kconfig.freezer"
+
 menu "Tilera-specific configuration"

 config NR_CPUS

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

