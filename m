Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3FJVdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:33:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3FJVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:33:15 -0400
Date: Mon, 10 Jun 2013 14:33:14 -0700 (PDT)
Message-Id: <20130610.143314.1237579707705274760.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tuntap: fix a possible race between queue selection
 and changing queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130605103332.GD31830@redhat.com>
References: <1370421897-30933-1-git-send-email-jasowang@redhat.com>
	<20130605103332.GD31830@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 5 Jun 2013 13:33:32 +0300

> On Wed, Jun 05, 2013 at 04:44:57PM +0800, Jason Wang wrote:
>> Complier may generate codes that re-read the tun->numqueues during
>> tun_select_queue(). This may be a race if vlan->numqueues were changed in the
>> same time and can lead unexpected result (e.g. very huge value).
>> 
>> We need prevent the compiler from generating such codes by adding an
>> ACCESS_ONCE() to make sure tun->numqueues were only read once.
>> 
>> Bug were introduced by commit c8d68e6be1c3b242f1c598595830890b65cea64a
>> (tuntap: multiqueue support).
>> 
>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> This is a theoretical problem, right?
> So no need for stable.

Applied, thanks.
