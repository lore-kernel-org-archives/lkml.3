Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaJFWOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:14:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38738 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaJFWOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:14:52 -0400
Date: Mon, 06 Oct 2014 18:14:48 -0400 (EDT)
Message-Id: <20141006.181448.1696747135961247651.davem@davemloft.net>
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, adobriyan@gmail.com,
        rui.xiang@huawei.com, viro@zeniv.linux.org.uk, oleg@redhat.com,
        gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu
Subject: Re: [PATCH linux v2 1/1] fs/proc: use a rb tree for the directory
 entries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412605834-4417-2-git-send-email-nicolas.dichtel@6wind.com>
References: <542EA009.4060009@6wind.com>
	<1412605834-4417-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412605834-4417-2-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Oct 2014 15:14:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon,  6 Oct 2014 16:30:34 +0200

> The current implementation for the directories in /proc is using a single
> linked list. This is slow when handling directories with large numbers of
> entries (eg netdevice-related entries when lots of tunnels are opened).
> 
> This patch replaces this linked list by a red-black tree.
> 
> Here are some numbers:
> 
> dummy30000.batch contains 30 000 times 'link add type dummy'.
 ...
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

FWIW:

Acked-by: David S. Miller <davem@davemloft.net>
