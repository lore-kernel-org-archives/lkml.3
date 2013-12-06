Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041Ab3LFSEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:04:21 -0500
Received: from relay.parallels.com ([195.214.232.42]:33035 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab3LFSET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:04:19 -0500
Message-ID: <52A211A1.8040809@parallels.com>
Date: Fri, 6 Dec 2013 22:04:17 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org> <52A1766F.5090808@parallels.com> <20131206161312.GC13373@htj.dyndns.org> <20131206162503.GD13373@htj.dyndns.org>
In-Reply-To: <20131206162503.GD13373@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 08:25 PM, Tejun Heo wrote:
> On Fri, Dec 06, 2013 at 11:13:12AM -0500, Tejun Heo wrote:
>>> Second, it's not clear to me why we need the CSS_ONLINE flag at all if
>>> we never assign css's that we fail to online to a cgroup. AFAIU we will
>>> never see such css's, because in all places we call offline_css(),
>>> namely cgroup_destroy_locked() (via kill_css()) and
>>> cgroup_unload_subsys(), we use cgroup_css() which will return NULL for them.
>> The whole thing is in flux and will look very different in near
>> future.  I actually had patches queued which deal with the issue you
>> spotted but they are being blocked on other changes ATM.  So, yeah,
>> there are some spurious stuff now.
> LOL, I found the patch.  It was posted and acked I just forgot to
> apply the whole series.  I'm a moron.
>
>   http://permalink.gmane.org/gmane.linux.kernel.containers/26804
>
> This should do it, right?  I'll update the patch description and
> repost the series.

If combined with the patch you've sent recently, this should do the trick.

Thanks.
