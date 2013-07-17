Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab3GQTbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:31:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab3GQTbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:31:24 -0400
Date: Wed, 17 Jul 2013 22:31:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes)
 causes hang
Message-ID: <20130717193100.GM13732@redhat.com>
References: <20130717163215.GA359@x4>
 <20130717164232.GI13732@redhat.com>
 <20130717165743.GA357@x4>
 <B438F263-D5D5-4755-AAAA-ED92F4F0379E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <B438F263-D5D5-4755-AAAA-ED92F4F0379E@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 03:07:11AM +0800, Xiao Guangrong wrote:
> Ouch!
> 
> The guest is hang when boot from ubuntu iso, i bisected the code and found it is caused by:
> 
> cad55f1aed000db46dfd1b5706707f33624d8604 is the first bad commit
> commit cad55f1aed000db46dfd1b5706707f33624d8604
> Author: Cornelia Huck <cornelia.huck@de.ibm.com>
> Date:   Wed Jul 3 16:30:53 2013 +0200
> 
>     KVM: kvm-io: support cookies
>     
>     Add new functions kvm_io_bus_{read,write}_cookie() that allows users of
>     the kvm io infrastructure to use a cookie value to speed up lookup of a
>     device on an io bus.
>     
>     Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Now, i have reset the code behind this commit and continue to install the guest…...
> 
You are on an old queue branch (the commit was never in next). I fixed it not long time ago. Can you
pull?

--
			Gleb.
