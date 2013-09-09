Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3IIGM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:12:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50198 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3IIGM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:12:27 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <522D66AE.4060702@jp.fujitsu.com>
Date: Mon, 9 Sep 2013 15:11:58 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH 2/2] mm/cleanup: use pfn_to_nid() instead of page_to_nid(pfn_to_page())
References: <522D403C.3040801@huawei.com>
In-Reply-To: <522D403C.3040801@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Kosaki since he maintains mm/memory_hotplug.c]

(2013/09/09 12:27), Xishi Qiu wrote:
> Use "pfn_to_nid(pfn)" instead of "page_to_nid(pfn_to_page(pfn))".
>

> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   mm/memory_hotplug.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 85f80b7..a95dd28 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -937,7 +937,7 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>   	arg.nr_pages = nr_pages;
>   	node_states_check_changes_online(nr_pages, zone, &arg);
>
> -	nid = page_to_nid(pfn_to_page(pfn));
> +	nid = pfn_to_nid(pfn);
>
>   	ret = memory_notify(MEM_GOING_ONLINE, &arg);
>   	ret = notifier_to_errno(ret);
>


