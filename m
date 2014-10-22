Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaJVUHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:07:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323AbaJVUHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:07:39 -0400
Message-ID: <54480E58.5060600@redhat.com>
Date: Wed, 22 Oct 2014 16:06:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, peterz@infradead.org,
        mingo@kernel.org
CC: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com, vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org
Subject: Re: [PATCH RFC 5/7] sched: cfs: cpu frequency scaling arch functions
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org> <1413958051-7103-6-git-send-email-mturquette@linaro.org>
In-Reply-To: <1413958051-7103-6-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/22/2014 02:07 AM, Mike Turquette wrote:
> arch_eval_cpu_freq and arch_scale_cpu_freq are added to allow the 
> scheduler to evaluate if cpu frequency should change and to invoke
> that change from a safe context.
> 
> They are weakly defined arch functions that do nothing by default.
> A CPUfreq governor could use these functions to implement a
> frequency scaling policy based on updates to per-task statistics or
> updates to per-cpu utilization.
> 
> As discussed at Linux Plumbers Conference 2014, the goal will be
> to focus on a single cpu frequency scaling policy that works for
> everyone. That may mean that the weak arch functions definitions
> can be removed entirely and a single policy implements that logic
> for all architectures.

On virtual machines, we probably want to use both frequency and
steal time to calculate the factor.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUSA5XAAoJEM553pKExN6DeRYH/jeXImjO2/WZFp82Yv6ukMxI
r8/kzrLMA+NS1XXCWYIcOiBqReEabkZZmypt21Tdnpkvi4GbZPpG0PEApSvOfqWE
w71J87cpMGV/e4uLcBDcvgHJX8RBQLO/ZqDcMm+zcSoeJ3G3NMK2YlZp3Uf8xqcB
tE2VGW7o2yEqNJL1fqYb++3upQmc10vIFqxVIJfP+TqZRyaVP+5kBqOMDTWb5qCV
qZjBKe1jDX5sLLGfY0ddAeuUH1iEJBIUMCcr027ezcqRp4YoqIrHRInHmNxEs5Az
9PN8N0yGgqhvkcCfXG7He+tQBHECOnjyQlrM/2K8Cw11RziwDkC/yYIp3DPgjxc=
=f/8V
-----END PGP SIGNATURE-----
