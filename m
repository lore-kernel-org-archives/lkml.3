Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3AVOln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:41:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3AVOll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:41:41 -0500
Message-ID: <1358865692.5782.420.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Tue, 22 Jan 2013 15:41:32 +0100
In-Reply-To: <50FE5433.1070801@linux.vnet.ibm.com>
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
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:zbnFd4eo78GbL9iQXdElEyJ/Ha/onSMl0c43PAyv/mM
 XahwugWkXmkqJnJIfdrd98tM/BoFFe+SSKduaYaQJ2zbAO2d2I
 9F3RSWGb/rZ0hBkuOS7TDMhuumlBVegpi0ORVvkl4fiGOvEcz0
 /vERoNKykeUjolYXjtf563973hbSvjydu3HJ6nmN1YqmV5rxKw
 exnT/AIhttvngHX7MmWecfpH6shBo2MFmfWkUXHJgujAvXj7Cj
 F9yEesUSfPSoEnsBpY9YV/izIGjFBg5Wazmo583YOYeV3UH5nv
 unbz/maXy18R34rkQmGfb1Zz2s8XPFVCmt2GxXLgEw0ZoeFVwI
 iVerqKOUxippV56V8T85c2yMeGPmYojDxMU7LUUlLprZQmyPbc
 d8GRiLR42SD9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 16:56 +0800, Michael Wang wrote:

> What about this patch? May be the wrong map is the killer on balance
> path, should we check it? ;-) 

[    1.232249] Brought up 40 CPUs
[    1.236003] smpboot: Total of 40 processors activated (180873.90 BogoMIPS)
[    1.244744] CPU0 attaching sched-domain:
[    1.254131] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.252010]  domain 0: span 0,16 level SIBLING
[    1.280001]   groups: 0 (cpu_power = 589) 16 (cpu_power = 589)
[    1.292540]   domain 1: span 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 level MC
[    1.312001]    groups: 0,16 (cpu_power = 1178) 2,18 (cpu_power = 1178) 4,20 (cpu_power = 1178) 6,22 (cpu_power = 1178) 8,24 (cpu_power = 1178)
                         10,26 (cpu_power = 1178)12,28 (cpu_power = 1178)14,30 (cpu_power = 1178)32,36 (cpu_power = 1178)34,38 (cpu_power = 1178)
[    1.368002]    domain 2: span 0-39 level NUMA
[    1.376001]     groups: 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38 (cpu_power = 11780)
                           1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39 (cpu_power = 11780)
[    1.412546] WYT: sbm of cpu 0
[    1.416001] WYT:      exec map
[    1.424002] WYT:              sd 6ce55000, idx 0, level 0, weight 2
[    1.436001] WYT:              sd 6ce74000, idx 1, level 1, weight 20
[    1.448001] WYT:              sd 6cef3000, idx 3, level 3, weight 40
[    1.460001] WYT:      fork map
[    1.468001] WYT:              sd 6ce55000, idx 0, level 0, weight 2
[    1.480001] WYT:              sd 6ce74000, idx 1, level 1, weight 20
[    1.492001] WYT:              sd 6cef3000, idx 3, level 3, weight 40
[    1.504001] WYT:      wake map
                                 Hi, we're not home right now...
[    1.508001] WYT:      affine map
[    1.516001] WYT:              affine with cpu 0 in sd 6ce55000, weight 2
[    1.528001] WYT:              affine with cpu 1 in sd 6cef3000, weight 40
[    1.544001] WYT:              affine with cpu 2 in sd 6ce74000, weight 20
[    1.556001] WYT:              affine with cpu 3 in sd 6cef3000, weight 40
[    1.568001] WYT:              affine with cpu 4 in sd 6ce74000, weight 20
[    1.584001] WYT:              affine with cpu 5 in sd 6cef3000, weight 40
[    1.596001] WYT:              affine with cpu 6 in sd 6ce74000, weight 20
[    1.608001] WYT:              affine with cpu 7 in sd 6cef3000, weight 40
[    1.624001] WYT:              affine with cpu 8 in sd 6ce74000, weight 20
[    1.636001] WYT:              affine with cpu 9 in sd 6cef3000, weight 40
[    1.648001] WYT:              affine with cpu a in sd 6ce74000, weight 20
[    1.660001] WYT:              affine with cpu b in sd 6cef3000, weight 40
[    1.676001] WYT:              affine with cpu c in sd 6ce74000, weight 20
[    1.688001] WYT:              affine with cpu d in sd 6cef3000, weight 40
[    1.700001] WYT:              affine with cpu e in sd 6ce74000, weight 20
[    1.716001] WYT:              affine with cpu f in sd 6cef3000, weight 40
[    1.728001] WYT:              affine with cpu 10 in sd 6ce55000, weight 2
[    1.740001] WYT:              affine with cpu 11 in sd 6cef3000, weight 40
[    1.756001] WYT:              affine with cpu 12 in sd 6ce74000, weight 20
[    1.768001] WYT:              affine with cpu 13 in sd 6cef3000, weight 40
[    1.780001] WYT:              affine with cpu 14 in sd 6ce74000, weight 20
[    1.796001] WYT:              affine with cpu 15 in sd 6cef3000, weight 40
[    1.808001] WYT:              affine with cpu 16 in sd 6ce74000, weight 20
[    1.820001] WYT:              affine with cpu 17 in sd 6cef3000, weight 40
[    1.836001] WYT:              affine with cpu 18 in sd 6ce74000, weight 20
[    1.848001] WYT:              affine with cpu 19 in sd 6cef3000, weight 40
[    1.860001] WYT:              affine with cpu 1a in sd 6ce74000, weight 20
[    1.876001] WYT:              affine with cpu 1b in sd 6cef3000, weight 40
[    1.888001] WYT:              affine with cpu 1c in sd 6ce74000, weight 20
[    1.900001] WYT:              affine with cpu 1d in sd 6cef3000, weight 40
[    1.916001] WYT:              affine with cpu 1e in sd 6ce74000, weight 20
[    1.928001] WYT:              affine with cpu 1f in sd 6cef3000, weight 40
[    1.940001] WYT:              affine with cpu 20 in sd 6ce74000, weight 20
[    1.956001] WYT:              affine with cpu 21 in sd 6cef3000, weight 40
[    1.968001] WYT:              affine with cpu 22 in sd 6ce74000, weight 20
[    1.984001] WYT:              affine with cpu 23 in sd 6cef3000, weight 40
[    1.996001] WYT:              affine with cpu 24 in sd 6ce74000, weight 20
[    2.008002] WYT:              affine with cpu 25 in sd 6cef3000, weight 40
[    2.024002] WYT:              affine with cpu 26 in sd 6ce74000, weight 20
[    2.036001] WYT:              affine with cpu 27 in sd 6cef3000, weight 40

