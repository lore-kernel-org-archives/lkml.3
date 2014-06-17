Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaFQOAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:00:19 -0400
Received: from smtp.opengridcomputing.com ([72.48.136.20]:53137 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133AbaFQOAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:00:18 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2014 10:00:18 EDT
From: "Steve Wise" <swise@opengridcomputing.com>
To: "'David Rientjes'" <rientjes@google.com>,
        "'Nick Krause'" <xerofoify@gmail.com>
Cc: <swise@chelsio.com>, <roland@kernel.org>, <sean.hefty@intel.com>,
        <hal.rosenstock@gmail.com>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com> <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com> <CAPDOMVg8hT95Wcmy4VHdfsumEvc=w3dz8V8xP1QScsLK3buSxw@mail.gmail.com> <alpine.DEB.2.02.1406161707230.21018@chino.kir.corp.google.com> <CAPDOMVjjwywH36guWC2q-Y26m-DEoHHJtk5Vasvk2kfsDpCuiA@mail.gmail.com> <alpine.DEB.2.02.1406161735490.21018@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406161735490.21018@chino.kir.corp.google.com>
Subject: RE: [PATCH] infiniband: Fixes memory leak in send_flowc
Date: Tue, 17 Jun 2014 08:53:01 -0500
Message-ID: <002201cf8a33$740fc730$5c2f5590$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQCl4K9OGHsDmNxTUoFf1Os0BPv3BQIL7OVvAvWTOKMBz17rRwKHZ9TnAfVsOhYCaUrVAJ1a7Vyw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On
> Behalf Of David Rientjes
> Sent: Monday, June 16, 2014 7:37 PM
> To: Nick Krause
> Cc: Steve Wise; swise@chelsio.com; roland@kernel.org; sean.hefty@intel.com;
> hal.rosenstock@gmail.com; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
> 
> On Mon, 16 Jun 2014, Nick Krause wrote:
> 
> > That's true David,
> > I will resend this parch without the use of the pr_warn.
> 
> There's no patch to resend if you don't use pr_warn().  kfree_skb(skb) is
> unnecessary if !skb, look at the first thing it checks:
> 
> void kfree_skb(struct sk_buff *skb)
> {
>         if (unlikely(!skb))
>                 return;
> 	...
> }
> 
> Thus, I don't see the memory leak you're referring to.

send_flowc() still needs to handle a NULL return from get_skb().  That is what the bug
report is addressing...

Steve.


