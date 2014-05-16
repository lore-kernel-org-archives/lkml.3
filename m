Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992521AbaEPTp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:45:28 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58685 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992428AbaEPTpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YPwkWQCtuE=sUReBzi+3ygvsawEovV-nfWLK2f3GDn9Kg@mail.gmail.com>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
	<1400257015-28222-4-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.10.1405161250350.492@gentwo.org>
	<20140516183500.GI5379@htj.dyndns.org>
	<alpine.DEB.2.10.1405161350360.1681@gentwo.org>
	<20140516190042.GJ5379@htj.dyndns.org>
	<alpine.DEB.2.10.1405161431590.2126@gentwo.org>
	<CAOS58YPwkWQCtuE=sUReBzi+3ygvsawEovV-nfWLK2f3GDn9Kg@mail.gmail.com>
Date: Fri, 16 May 2014 15:45:23 -0400
X-Google-Sender-Auth: Fg5eWOHLSk6aGV7305a3yY89O6s
Message-ID: <CAOS58YOTAEGP+=sgSGVDLW+X11QZ_s9jTyRwmpeUD9JQiWbjQQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] workqueue: Create low-level unbound workqueues cpumask
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, May 16, 2014 at 3:34 PM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, May 16, 2014 at 3:32 PM, Christoph Lameter <cl@linux.com> wrote:
>> It sets a bad precedent. So move to /sys/kernel/workqueue and lets have a
>> symlink that goes back?
>
> Hmm... I don't think it's a good idea to lose uevent. It's an integral
> part in configuring sysfs. Wouldn't it make more sense to move
> /sys/kernel under /sys/devices?

So, the thing is sysfs has been collecting everything under
/sys/devices because other top level directories added complexity
while missing out on basic event mechanism. If you look at other
top-level directories, other than /sys/modules and /sys/kernel,
everything else is symlink into /sys/devices hierarchy and just kept
around for compatibility. For static knobs, it may not matter but for
things like slab and workqueue which can be dynamically created and
destroyed, being hooked up into uevent mechanism is a necessity, so I
really think we better sort it out properly. Maybe it can use
/sys/devices/virtual or maybe we'll need a separate directory such
/sys/devices/kernel but I really don't find moving workqueue to
/sys/kernel at this point a good idea.

Thanks.

-- 
tejun
