Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaDRQ5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:57:12 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:55933 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaDRQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:57:09 -0400
Date: Fri, 18 Apr 2014 12:57:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 2/8] idr: fix unexpected id-removal when
 idr_remove(unallocated_id)
Message-ID: <20140418165705.GE12515@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:49:49PM +0800, Lai Jiangshan wrote:
> If unallocated_id = (ANY * idr_max(idp->layers) + existed_id) is passed

						    existing_id

> to idr_remove(). The existed_id will be removed unexpected.

                       ditto.

> 
> The following test shows this unexpected id-removal:
> 
> static void test4(void)
> {
> 	int id;
> 	DEFINE_IDR(test_idr);
> 
> 	printk(KERN_INFO "Start test4\n");
> 	id = idr_alloc(&test_idr, (void *)1, 42, 43, GFP_KERNEL);
> 	BUG_ON(id != 42);
> 	idr_remove(&test_idr, 42 + IDR_SIZE);
> 	TEST_BUG_ON(idr_find(&test_idr, 42) != (void *)1);
> 	idr_destroy(&test_idr);
> 	printk(KERN_INFO "End of test4\n");
> }
> 
> It only happens when unallocated_id, it is caller's fault. It is not
> a bug. But it is better to add the proper check and complains instead

							complain

> of removing an existed_id silently.

                existing_id

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
