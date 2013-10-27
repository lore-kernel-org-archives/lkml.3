Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3J0Mfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 08:35:48 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:54457 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab3J0Mfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 08:35:46 -0400
Date: Sun, 27 Oct 2013 08:35:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] percpu: merge two loops when setting up group info
Message-ID: <20131027123542.GK14934@mtj.dyndns.org>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <1382345893-6644-2-git-send-email-weiyang@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382345893-6644-2-git-send-email-weiyang@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 04:58:12PM +0800, Wei Yang wrote:
> There are two loops setting up the group info of pcpu_alloc_info. They share
> the same logic, so merge them could be time efficient when there are many
> groups.
> 
> This patch merge these two loops into one.

It *looks* correct to me but I'd rather not change this unless you can
show me this actually matters, which I find extremely doubtful given
nr_groups would be in the order of few thousands even on an extremely
large machine.

Thanks.

-- 
tejun
