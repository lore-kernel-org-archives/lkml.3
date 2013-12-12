Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3LLSpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:45:22 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:52184 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LLSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:45:18 -0500
Date: Thu, 12 Dec 2013 13:45:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Message-ID: <20131212184506.GK32683@htj.dyndns.org>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
 <20131212153536.GD32683@htj.dyndns.org>
 <20131212155523.GF32683@htj.dyndns.org>
 <52AA026C.3040605@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA026C.3040605@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 12, 2013 at 10:37:32PM +0400, Vladimir Davydov wrote:
> If so, I don't mind, but why? cgroup_unload_subsys() should never be
> called without properly initialized css.

Hmm.... I think it's generally preferable to reuse normal exit path
for error handling as much as possible.  Plus, the normal cgroup init
failure path behaves that way.  That said, it's more of a preference
and if you have technical argument, I'd be happy to give in. :)

Thanks.

-- 
tejun
