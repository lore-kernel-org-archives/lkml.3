Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbaJaK5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:57:42 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757338AbaJaK5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:57:41 -0400
Message-ID: <54536B22.4000807@nod.at>
Date: Fri, 31 Oct 2014 11:57:38 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: hujianyang <hujianyang@huawei.com>
CC: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: vtbl: Use ubi_eba_atomic_leb_change()
References: <1414259021-5691-1-git-send-email-richard@nod.at> <1414659349.23185.27.camel@sauron.fi.intel.com> <54530A29.9070208@huawei.com> <545343CA.7080507@nod.at> <54536834.1020005@huawei.com>
In-Reply-To: <54536834.1020005@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.10.2014 um 11:45 schrieb hujianyang:
> This question is basing on your comment for this patch:
> 
> """
> we can guarantee that the first VTBL record is always
> correct and we don't really need the second one anymore.
> """
> 
> I think that means one PEB is enough in your considering.
> So I want to know if you are sure about this. Because
> we use two leb for master_node in ubifs-level. So maybe
> VTBL is like super_node, not master_node, right?

Yes, technically one PEB is enough if atomic leb change is used.
But existing UBI implementations want a second one
and a backup VTBL PEB is good for robustness.
i.e. if the PEB turns bad we have a backup and do not lose
all volume meta information.

Thanks,
//richard
