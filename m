Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaKGLWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:22:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38086 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKGLWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:22:04 -0500
Message-ID: <1415359320.13896.105.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [Xen-devel] BUG in xennet_make_frags with paged skb data
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Zoltan Kiss <zoltan.kiss@linaro.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Date: Fri, 07 Nov 2014 03:22:00 -0800
In-Reply-To: <545C9013.1090406@linaro.org>
References: <20141106214940.GD44162@ubuntu-hedt>
	 <545C9013.1090406@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 09:25 +0000, Zoltan Kiss wrote:

Please do not top post.

> Hi,
> 
> AFAIK in this scenario your skb frag is wrong. The page pointer should 
> point to the original compound page (not a member of it), and offset 
> should be set accordingly.
> For example, if your compound page is 16K (4 page), then the page 
> pointer should point to the first page, and if the data starts at the 
> 3rd page, then offset should be >8K

This is not accurate.

This BUG_ON() is wrong.

It should instead be :

BUG_ON(len + offset > PAGE_SIZE<<compound_order(compound_head(page)));

splice() code can generate such cases.


