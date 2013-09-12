Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3ILVWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:22:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38813 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3ILVWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:22:44 -0400
Date: Thu, 12 Sep 2013 17:22:41 -0400 (EDT)
Message-Id: <20130912.172241.886631046673790242.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wannes.rombouts@epitech.eu
Subject: Re: [PATCH net V2] tuntap: correctly handle error in tun_set_iff()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130911104350.GA25316@redhat.com>
References: <1378894188-8015-1-git-send-email-jasowang@redhat.com>
	<20130911104350.GA25316@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Sep 2013 14:22:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 11 Sep 2013 13:43:50 +0300

> On Wed, Sep 11, 2013 at 06:09:48PM +0800, Jason Wang wrote:
>> Commit c8d68e6be1c3b242f1c598595830890b65cea64a
>> (tuntap: multiqueue support) only call free_netdev() on error in
>> tun_set_iff(). This causes several issues:
>> 
>> - memory of tun security were leaked
>> - use after free since the flow gc timer was not deleted and the tfile
>>   were not detached
>> 
>> This patch solves the above issues.
>> 
>> Reported-by: Wannes Rombouts <wannes.rombouts@epitech.eu>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied and queued up for -stable, thanks.
