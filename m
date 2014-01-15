Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaAON7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:59:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaAON7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:59:33 -0500
Date: Wed, 15 Jan 2014 14:59:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Victor Porton <porton@narod.ru>
Cc: linux-kernel@vger.kernel.org,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: Notifying on empty cgroup
Message-ID: <20140115135930.GK8782@dhcp22.suse.cz>
References: <135711389759165@web22h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <135711389759165@web22h.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing cgroups mailing list]
On Wed 15-01-14 06:12:45, Victor Porton wrote:
> I want to write software which needs to receive a signal when the cgroup 
> created by it becomes empty. (After this the empty cgroup should be deleted 
> just not to clutter the memory.)
> 
> If the kernel does not support such notifications, it should be improved. 
> This functionality is crucial for some kinds of software.
> 
> There is /sys/fs/cgroup/systemd/release_agent but I don't understand how to 
> use it. I don't understand why we would need it at all.

"1.4 What does notify_on_release do ?" in
Documentation/cgroups/cgroups.txt the kernel source doesn't help?

> Starting a binary on emptying a cgroup with the purpose to notify an other 
> binary looks like a big overkill.

the binary can do rmdir which is what you want, no?

> Also my program should work in userspace without the need to use
> release_agent which can be accessed only by root.

The release_agent is global for all groups so the program doesn't have
to care.

> Note that my work is related with sandboxing software (running a program in 
> closed environment, so that it would be unable for example to remove user's 
> files).
> 
> See also
> http://portonsoft.wordpress.com/2014/01/11/toward-robust-linux-sandbox/
> 
> -- 
> Victor Porton - http://portonvictor.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
