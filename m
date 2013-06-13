Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab3FMRRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:17:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:48056 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab3FMRRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,860,1363158000"; 
   d="scan'208";a="328984651"
Message-ID: <51B9FE8E.9000109@intel.com>
Date: Thu, 13 Jun 2013 10:17:02 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part3 PATCH v2 2/4] mem-hotplug: Skip LOCAL_NODE_DATA pages
 in memory offline procedure.
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com> <1371128636-9027-3-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1371128636-9027-3-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 06:03 AM, Tang Chen wrote:
> +static inline bool is_local_node_data(struct page *page)
> +{
> +	return (unsigned long)page->lru.next == LOCAL_NODE_DATA;
> +}

page->lru is already in a union.  Could you please just add a new entry
to the union with a nice associated comment instead of reusing it this way?
