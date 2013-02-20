Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805Ab3BTNZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:25:34 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44523
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935457Ab3BTNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:25:32 -0500
Message-ID: <1361366720.10155.25.camel@laptop>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 20 Feb 2013 14:25:20 +0100
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
> +struct sched_balance_map {
> +       struct sched_domain **sd[SBM_MAX_TYPE];
> +       int top_level[SBM_MAX_TYPE];
> +       struct sched_domain *affine_map[NR_CPUS];
> +};

Argh.. affine_map is O(n^2) in nr_cpus, that's not cool.

