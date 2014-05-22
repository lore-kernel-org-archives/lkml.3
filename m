Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaEVT7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:59:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49684 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaEVT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:59:42 -0400
Message-ID: <1400788778.5367.163.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: skbuff truesize incorrect.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jim Baxter <jim_baxter@mentor.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kamal@canonical.com,
        Ben Hutchings <bhutchings@solarflare.com>, edumazet@google.com,
        mszeredi@suse.cz, fw@strlen.de
Date: Thu, 22 May 2014 12:59:38 -0700
In-Reply-To: <537E526F.8060608@mentor.com>
References: <537E4AFD.20304@mentor.com> <537E4F29.9080103@gmail.com>
	 <537E526F.8060608@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 20:39 +0100, Jim Baxter wrote:

> I now think that the correct solution here is to create a new smaller
> skb and copy the data from the sub packets into it.

For low speed devices, this is indeed the best way.

(this is called copybreak in some nic drivers)



