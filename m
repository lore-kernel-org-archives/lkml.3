Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab3BTNVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:21:17 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44489
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934923Ab3BTNVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:21:15 -0500
Message-ID: <1361366462.10155.24.camel@laptop>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 20 Feb 2013 14:21:02 +0100
In-Reply-To: <510791B2.6090506@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <510791B2.6090506@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 17:09 +0800, Michael Wang wrote:
> +       for_each_possible_cpu(cpu) {
> +               sbm = &per_cpu(sbm_array, cpu);
> +               node = cpu_to_node(cpu);
> +               size = sizeof(struct sched_domain *) * sbm_max_level;
> +
> +               for (type = 0; type < SBM_MAX_TYPE; type++) {
> +                       sbm->sd[type] = kmalloc_node(size, GFP_KERNEL,
> node);
> +                       WARN_ON(!sbm->sd[type]);
> +                       if (!sbm->sd[type])
> +                               goto failed;
> +               }
> +       }

You can't readily use kmalloc_node() here, cpu_to_node() might return an
invalid node for offline cpus here.

Also see: 2ea45800d8e1c3c51c45a233d6bd6289a297a386

