Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaFTSgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:36:42 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:34953 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaFTSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:36:41 -0400
Message-ID: <1403288831.25108.0.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/2] x86,mem-hotplug: pass sync_global_pgds() a correct
 argument in remove_pagetable()
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, tangchen@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, guz.fnst@cn.fujitsu.com,
        zhangyanfei@cn.fujitsu.com
Date: Fri, 20 Jun 2014 12:27:11 -0600
In-Reply-To: <53A1339E.2000000@jp.fujitsu.com>
References: <53A132E2.9000605@jp.fujitsu.com>
	 <53A1339E.2000000@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 15:37 +0900, Yasuaki Ishimatsu wrote:
> remove_pagetable() gets start argument and passes the argument to
> sync_global_pgds(). In this case, the argument must not be modified.
> If the argument is modified and passed to sync_global_pgds(),
> sync_global_pgds() does not correctly synchronize PGD to PGD entries
> of all processes MM since synchronized range of memory [start, end]
> is wrong.
> 
> Unfortunately the start argument is modified in remove_pagetable().
> So this patch fixes the issue.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


