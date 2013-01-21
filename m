Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3AUHJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:09:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AUHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:09:46 -0500
Message-ID: <1358752180.4994.65.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 08:09:40 +0100
In-Reply-To: <1358750523.4994.55.camel@marge.simpson.net>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:p9S0mh58TsJ+gBUI3yhrQ13RGIg9lrrHih+KC+2N5gu
 s9Q8Nxn/xWhnPiuDc2coYyx9+G5EA6kQ+tG5ACM51nz6F4fExo
 uyS6VtQbXPwaNmnAKB0Am4lpbUOPGitSfK8YWfqgJUWfpZfASD
 OCUAnQBSoPVUp0IMkBIhbaRUB5qhGMZAKSK5xxLVD31EZZN+Or
 iWkv/8QS+KWHBngk2ntJDMomVFOSONetAZf3D6z+bdQCgJAQ55
 Iq7rOX5kvrdljPLhYK5sNJph7eAzCuomC7qoTuEfpwmTxKzPp/
 Pr5UVcYJXFPqtgwWmFGRspOq20UN4E8Pgzutso/sA3WT4Sw4tT
 L0OAN/6/7dlRd8uRwUEdPoVo747Ybn727y3xznDfiNP3Exs9aG
 AK5Ti/6mX8DEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:

> > May be we could try change this back to the old way later, after the aim
> > 7 test on my server.
> 
> Yeah, something funny is going on.

Never entering balance path kills the collapse.  Asking wake_affine()
wrt the pull as before, but allowing us to continue should no idle cpu
be found, still collapsed.  So the source of funny behavior is indeed in
balance_path.

-Mike

