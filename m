Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3AOEwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:52:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3AOEwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:52:21 -0500
Message-ID: <1358225532.25910.37.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Tue, 15 Jan 2013 05:52:12 +0100
In-Reply-To: <50F4C8AB.6050902@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F4C8AB.6050902@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Vz+5DygFzWxv0QZuklx1PTqo1vDv4hFHpE3oLc4XgK4
 WlHF/wz9V2ozhAuuZILDsIQBpay1ZQOhUGY7c2a4YzVG+IlnoC
 kvOvnF1UMe8yb2tdw1k/ERLDrMtta95WyFKRXYF8g3DqddEMtZ
 nHpfuW5lyudzaJcufnxeCd087DGmwJSTx4X8l0C9q+RJ9A3Ww9
 AfVF0Lt21gjg5srfo6X05JIqAHOnFWu0EIejgeLu3Jxnvgz7mF
 uwGxP0+gF4DkW0wfSGDzFHCQijteC2bjxNIeAN7DcePKBQqbV1
 KDb9US0g3cYDlBSfowUgHSJ28KIi/+CQlKyS7uS/qfFfBqxsSt
 zRmpV3AuwyLpoUmSbHx7jpLO40EmcpBNbuZMOXM8QJGMqpmBCL
 IcJLhSAp90Pvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 11:10 +0800, Michael Wang wrote: 
> hanks for the testing, could you please tell me which benchmark
> generate these results?

aim7, using the compute workfile, and a datapoints file containing
$Tasks.  multitask -nl -f will prompt for the datapoints file.  You'll
have to bump /proc/sys/kernel/sem if it's left at default by your
distro.  If you want, I can send you a tarball offline.

> I will try to re-base the patch into 3.8-rc3 with consideration of NUMA
> domain, I suppose it could fix the below BUG and provide a better results.

I don't _think_ you'll fix the sweet spot without setting knobs such
that last_buddy can do its thing, but go for it ;-)

-Mike

