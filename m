Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3D3IDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:03:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41419 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3D3IDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:03:48 -0400
Date: Tue, 30 Apr 2013 04:03:46 -0400 (EDT)
Message-Id: <20130430.040346.1354791082943611347.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net,
        ajit.khaparde@emulex.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130426134814.17f27efe88073999dcf634bb@canb.auug.org.au>
References: <20130426134814.17f27efe88073999dcf634bb@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Apr 2013 01:03:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 26 Apr 2013 13:48:14 +1000

> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/net/ethernet/emulex/benet/be_main.c: In function 'be_insert_vlan_in_pkt':
> drivers/net/ethernet/emulex/benet/be_main.c:786:3: error: too few arguments to function '__vlan_put_tag'
> include/linux/if_vlan.h:220:31: note: declared here
> drivers/net/ethernet/emulex/benet/be_main.c:796:3: error: too few arguments to function '__vlan_put_tag'
> include/linux/if_vlan.h:220:31: note: declared here
> 
> Caused by comt interaction of commit 86a9bad3ab6b ("net: vlan: add
> protocol argument to packet tagging functions") from the net-next tree
> and commit bc0c3405abbb ("be2net: fix a Tx stall bug caused by a specific
> ipv6 packet") from the net tree.
> 
> I applied the following merge fix patch:

I fixed this in the merge commit when I merged net into net-next, thanks!
