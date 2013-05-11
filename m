Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3EKXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 19:25:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60255 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3EKXZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 19:25:55 -0400
Date: Sat, 11 May 2013 16:25:54 -0700 (PDT)
Message-Id: <20130511.162554.1852680841693318294.davem@davemloft.net>
To: jiri@resnulli.us
Cc: netdev@vger.kernel.org, sri@us.ibm.com, kaber@trash.net,
        linux-kernel@vger.kernel.org, mtesar@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [patch net] macvlan: fix passthru mode race between dev
 removal and rx path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1368109420-14199-1-git-send-email-jiri@resnulli.us>
References: <1368109420-14199-1-git-send-email-jiri@resnulli.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu,  9 May 2013 16:23:40 +0200

> Currently, if macvlan in passthru mode is created and data are rxed and
> you remove this device, following panic happens:
> 
> NULL pointer dereference at 0000000000000198
> IP: [<ffffffffa0196058>] macvlan_handle_frame+0x153/0x1f7 [macvlan]
> 
> I'm using following script to trigger this:
 ...
> I run this script while "ping -f" is running on another machine to send
> packets to e1 rx.
> 
> Reason of the panic is that list_first_entry() is blindly called in
> macvlan_handle_frame() even if the list was empty. vlan is set to
> incorrect pointer which leads to the crash.
> 
> I'm fixing this by protecting port->vlans list by rcu and by preventing
> from getting incorrect pointer in case the list is empty.
> 
> Introduced by: commit eb06acdc85585f2 "macvlan: Introduce 'passthru' mode to takeover the underlying device"
> 
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>

Applied and queued up for -stable, thanks!
