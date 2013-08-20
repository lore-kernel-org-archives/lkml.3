Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab3HTQ54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:57:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35248 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HTQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:57:54 -0400
Message-ID: <5213A002.7020408@infradead.org>
Date: Tue, 20 Aug 2013 09:57:38 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] docs: Document soft dirty behaviour for freshly created
 memory regions
References: <20130820153132.GK18673@moon>
In-Reply-To: <20130820153132.GK18673@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/13 08:31, Cyrill Gorcunov wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  Documentation/vm/soft-dirty.txt |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-2.6.git/Documentation/vm/soft-dirty.txt
> ===================================================================
> --- linux-2.6.git.orig/Documentation/vm/soft-dirty.txt
> +++ linux-2.6.git/Documentation/vm/soft-dirty.txt
> @@ -28,6 +28,13 @@ This is so, since the pages are still ma
>  the kernel does is finds this fact out and puts both writable and soft-dirty
>  bits on the PTE.
>  
> +  While in most cases tracking memory changes by #PF-s is more than enough
                                                                       enough,

> +there is still a scenario when we can loose soft dirty bit -- a task does
                                         lose soft dirty bits -- a task

> +unmap previously mapped memory region and then maps new one exactly at the

   unmaps a previously mapped memory region and then maps a new one at exactly the

> +same place. When unmap called the kernel internally clears PTEs values

               When unmap is called, the kernel internally clears PTE values

> +including soft dirty bit. To notify user space application about such
                        bits.

> +memory region renewal the kernel always mark new memory regions (and
                                           marks

> +expanded regions) as soft dirtified.

or:                  as soft dirty.

>  
>    This feature is actively used by the checkpoint-restore project. You
>  can find more details about it on http://criu.org
> --


-- 
~Randy
