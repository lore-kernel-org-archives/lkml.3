Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab3GBI4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:56:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:39567 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321Ab3GBI4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:56:49 -0400
Message-ID: <1372755248.3616.5.camel@pasglop>
Subject: Re: [PATCH] Add hsize argument in write_buf call of
 pstore_ftrace_call
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, kbuild-all@01.org, rostedt@goodmis.org
Date: Tue, 02 Jul 2013 18:54:08 +1000
In-Reply-To: <20130702053611.11466.71343.stgit@aruna-ThinkPad-T420>
References: <20130702053611.11466.71343.stgit@aruna-ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 11:06 +0530, Aruna Balakrishnaiah wrote:
> Incorporate the addition of hsize argument in write_buf callback
> of pstore.

Thanks. I've added that to powerpc-next. It should hit Stephen tomorrow.

Cheers,
Ben.

> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> ---
> 
>  fs/pstore/ftrace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/pstore/ftrace.c b/fs/pstore/ftrace.c
> index 43b1280..76a4eeb 100644
> --- a/fs/pstore/ftrace.c
> +++ b/fs/pstore/ftrace.c
> @@ -44,7 +44,7 @@ static void notrace pstore_ftrace_call(unsigned long ip,
>  	rec.parent_ip = parent_ip;
>  	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
>  	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
> -			  sizeof(rec), psinfo);
> +			  0, sizeof(rec), psinfo);
>  
>  	local_irq_restore(flags);
>  }


