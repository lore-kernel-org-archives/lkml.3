Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3ILMAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:00:09 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33701 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3ILMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:00:08 -0400
Message-ID: <1378987204.24408.1.camel@edumazet-glaptop>
Subject: Re: [PATCH] Inet-hashtable: Change the range of sk->hash lock to
 avoid the race condition.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: edumazet@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 05:00:04 -0700
In-Reply-To: <1379003549.12328.6.camel@chenjun-workstation>
References: <1379003549.12328.6.camel@chenjun-workstation>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 12:32 -0400, Jun Chen wrote:
> When try to add node to list in __inet_hash_nolisten function, first get the
> list and then to lock for using, but in extremeness case, others can del this
> node before locking it, then the node should be null.So this patch try to lock
> firstly and then get the list for using to avoid this race condition.

I suspect another bug. This should not happen.

Care to describe the problem you got ?

Thanks


