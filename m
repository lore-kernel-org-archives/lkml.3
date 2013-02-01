Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3BAAqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 19:46:16 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:12003 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3BAAqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 19:46:14 -0500
Message-ID: <510B1051.5010200@tilera.com>
Date: Thu, 31 Jan 2013 19:46:09 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kbuild test robot <fengguang.wu@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt' undeclared
References: <510aa746.fVU8ZdQ2hys/RwjS%fengguang.wu@intel.com> <20130131231433.GM6824@mtj.dyndns.org>
In-Reply-To: <20130131231433.GM6824@mtj.dyndns.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/2013 6:14 PM, Tejun Heo wrote:
> Hello, guys.
>
> On Fri, Feb 01, 2013 at 01:17:58AM +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
>> head:   04c2eee5b9dfcb13f3cd07a5537fb8c785f2751a
>> commit: a3201227f803ad7fd43180c5195dbe5a2bf998aa freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE
>> date:   1 year, 2 months ago
> Heh, this gone goes way back.
>
>> config: make ARCH=tile allyesconfig
>>
>> All error/warnings:
>>
>>    kernel/cgroup_freezer.c: In function 'freezer_destroy':
>>>> kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt' undeclared (first use in this function)
>>    kernel/cgroup_freezer.c:151:3: note: each undeclared identifier is reported only once for each function it appears in
>>    kernel/cgroup_freezer.c: In function 'freezer_fork':
>>    kernel/cgroup_freezer.c:209:3: error: implicit declaration of function 'freeze_task'
>>    kernel/cgroup_freezer.c: In function 'unfreeze_cgroup':
>>    kernel/cgroup_freezer.c:296:3: error: implicit declaration of function '__thaw_task'
>>    kernel/cgroup_freezer.c: In function 'freezer_change_state':
>>>> kernel/cgroup_freezer.c:315:4: error: 'system_freezing_cnt' undeclared (first use in this function)
> So, CONFIG_FREEZER is defbool which is turned on automatically if
> CONFIG_CGROUP_FREEZER; however, CONFIG_FREEZER is defined in
> Kconfig.freezer which should be included by arch Kconfig file.  tile
> doesn't include it (maybe it doesn't want freezer for some reason?).

We have never had a customer ask for suspend-to-RAM or other similar modes.  As far as I know no one has looked into FREEZER or SUSPEND.  That said, there's no particular reason not to just try it and see if it works.

> CONFIG_COGRUP_FREEZER is in init/Kconfig, so allyesconfig enables it
> but as CONFIG_FREEZER definition isn't visible, we end up with broken
> config CONFIG_CGROUP_FREEZER && !CONFIG_FREEZER.
>
> Maybe we need to move CONFIG_CGROUP_FREEZER to Kconfig.freezer if tile
> actually doesn't want freezer?

That seems reasonable to me, but I'm happy to experiment with including Kconfig.freezer from the arch/tile/Kconfig if that feels like a better solution.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

