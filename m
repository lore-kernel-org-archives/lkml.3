Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbbAVBy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:54:56 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:45462 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbAVByu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:54:50 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 22 Jan 2015 10:55:48 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [mm/slub] BUG: using smp_processor_id() in preemptible
 [00000000] code: swapper/0/1
Message-ID: <20150122015548.GD21444@js1304-P5Q-DELUXE>
References: <1421815115.6126.19.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421815115.6126.19.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:38:35PM +0800, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit d2dc80750ee05ceb03c9b13b0531a782116d1ade ("mm/slub: optimize alloc/free fastpath by removing preemption on/off")
> 
> 
> +-------------------------------------------------------------+------------+------------+
> |                                                             | 8e32336269 | d2dc80750e |
> +-------------------------------------------------------------+------------+------------+
> | boot_successes                                              | 8          | 4          |
> | boot_failures                                               | 2          | 16         |
> | WARNING:at_net/netlink/genetlink.c:#genl_unbind()           | 2          | 5          |
> | backtrace:do_group_exit                                     | 2          | 5          |
> | backtrace:SyS_exit_group                                    | 2          | 5          |
> | BUG:using_smp_processor_id()in_preemptible[#]code:swapper   | 0          | 6          |
> | backtrace:getname_kernel                                    | 0          | 6          |
> | backtrace:run_init_process                                  | 0          | 6          |
> | backtrace:do_execve                                         | 0          | 6          |
> | BUG:using_smp_processor_id()in_preemptible[#]code:init      | 0          | 1          |
> | backtrace:vfs_stat                                          | 0          | 1          |
> | backtrace:SyS_stat64                                        | 0          | 1          |
> | BUG:using_smp_processor_id()in_preemptible[#]code:kdevtmpfs | 0          | 5          |
> | backtrace:devtmpfsd                                         | 0          | 5          |
> | backtrace:security_inode_alloc                              | 0          | 5          |
> | backtrace:inode_init_always                                 | 0          | 5          |
> +-------------------------------------------------------------+------------+------------+
> 

Hello,

I already sent the patch to fix the problem.

https://lkml.org/lkml/2015/1/19/17

Thanks for reporting.

Thanks.
