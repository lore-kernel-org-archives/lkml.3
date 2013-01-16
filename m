Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3APCLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:11:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44079 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757741Ab3APCLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:11:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,476,1355068800"; 
   d="scan'208";a="6594942"
Subject: Re: [PATCH] sched: reduce sched_domain_topology space
From: li guang <lig.fnst@cn.fujitsu.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: mingo@redhat.com, peterz@infradead.org, Morten.Rasmussen@arm.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <87r4llnbed.fsf@sejong.aot.lge.com>
References: <1358241318-20168-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <87r4llnbed.fsf@sejong.aot.lge.com>
Date: Wed, 16 Jan 2013 10:09:26 +0800
Message-ID: <1358302166.23348.7.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 10:10:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 10:10:45,
	Serialize complete at 2013/01/16 10:10:45
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-01-16三的 10:51 +0900，Namhyung Kim写道：
> Hi, liguang
> 
> On Tue, 15 Jan 2013 17:15:18 +0800, liguang wrote:
> > sched_domain_topology space was allocated by the size
> > ARRAY_SIZE(default_topology) + sched_domains_numa_levels,
> > suppose CONFIG_SCHED_SMT, CONFIG_SCHED_MC were y,
> > "static struct sched_domain_topology_level default_topology[] = {
> >          { sd_init_SIBLING, cpu_smt_mask, },
> >          { sd_init_MC, cpu_coregroup_mask, },
> >          { sd_init_CPU, cpu_cpu_mask, },
> >          { NULL, },
> > };"
> > then, ARRAY_SIZE(default_topology) equals to 4,
> > default_topology's NULL entry was accounted,
> > but, the following allocation for other sched_domains_numa_levels
> > entries was startd at 3(for default_topology[3].init is NULL),
> > so, 1 entry was forgot.
> 
> I don't think it's forgotten.
> 
> The sched_domain_topology still needs NULL entry at the end.  So what
> the current code does is to set up following sched_domain_topology:
> 
> { default_topology (without last NULL entry), numa topology, NULL }
> 
> Thanks,
> Namhyung

Oh, that's a trick!
Thanks!

-- 
regards!
li guang

