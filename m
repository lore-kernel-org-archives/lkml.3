Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3IMB6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:58:37 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:54343
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687Ab3IMB6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:58:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1155h)
Date: Fri, 13 Sep 2013 09:55:03 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] module: Make wait module's refcount to zero
 procedure as async
Message-ID: <20130913015502.GA20706@shlinux1.ap.freescale.net>
References: <1378955676-12708-1-git-send-email-peter.chen@freescale.com>
 <87ioy536mu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87ioy536mu.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:00:33AM +0930, Rusty Russell wrote:
> Peter Chen <peter.chen@freescale.com> writes:
> > Currently, if module's refcount is not zero during the unload,
> > it waits there until the user decreases that refcount.
> 
> Hi Peter,
> 
>         In practice userspace uses O_NONBLOCK.  In fact, I've been
> thinking of removing the blocking case altogether, since it's not really
> what people want.
> 
> That would solve your problem and make the code simpler.  Thoughts?
> 

So, it will like "Force unload" case, right?
If it is the case, it is better have a warning message to indicate
some users are still using it, since there may null pointer
dereference when the user module has unloaded, and the end user
can understand it may be triggered by wrong module unload sequence.

Thanks.

-- 

Best Regards,
Peter Chen

