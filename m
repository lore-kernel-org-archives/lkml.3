Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaFKHbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:31:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43061 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaFKHbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:31:19 -0400
Date: Wed, 11 Jun 2014 00:31:17 -0700 (PDT)
Message-Id: <20140611.003117.1126488754203319453.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, sergei.shtylyov@cogentembedded.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ip_vti: Fix 'ip tunnel add' with 'key' parameters
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140608020625.87ea7e0baeb32c77f2028742@qrator.net>
References: <20140608020625.87ea7e0baeb32c77f2028742@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 00:31:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Sun, 8 Jun 2014 02:06:25 +0400

> ip tunnel add remote 10.2.2.1 local 10.2.2.2 mode vti ikey 1 okey 2
> translates to p->iflags = VTI_ISVTI|GRE_KEY and p->i_key = 1, but GRE_KEY !=
> TUNNEL_KEY, so ip_tunnel_ioctl would set i_key to 0 (same story with o_key) 
> making us unable to create vti tunnels with [io]key via ip tunnel.
> 
> We cannot simply translate GRE_KEY to TUNNEL_KEY (as GRE module does) because 
> vti_tunnels with same local/remote addresses but different ikeys will be treated
> as different then. So, imo the best option here is to move p->i_flags & *_KEY 
> check for vti tunnels from ip_tunnel.c to ip_vti.c and to think about [io]_mark
> field for ip_tunnel_parm in the future.
> 
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>

Applied, thanks.
