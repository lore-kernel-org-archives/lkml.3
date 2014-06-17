Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaFQAhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:37:00 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61828 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaFQAg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:36:58 -0400
Date: Mon, 16 Jun 2014 17:36:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Krause <xerofoify@gmail.com>
cc: Steve Wise <swise@opengridcomputing.com>, swise@chelsio.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
In-Reply-To: <CAPDOMVjjwywH36guWC2q-Y26m-DEoHHJtk5Vasvk2kfsDpCuiA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1406161735490.21018@chino.kir.corp.google.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com> <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com> <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw@mail.gmail.com>
 <alpine.DEB.2.02.1406161707230.21018@chino.kir.corp.google.com> <CAPDOMVjjwywH36guWC2q-Y26m-DEoHHJtk5Vasvk2kfsDpCuiA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Nick Krause wrote:

> That's true David,
> I will resend this parch without the use of the pr_warn.

There's no patch to resend if you don't use pr_warn().  kfree_skb(skb) is 
unnecessary if !skb, look at the first thing it checks:

void kfree_skb(struct sk_buff *skb)
{
        if (unlikely(!skb))
                return;
	...
}

Thus, I don't see the memory leak you're referring to.
