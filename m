Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3GQVxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:53:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:5602 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab3GQVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:53:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,687,1367996400"; 
   d="scan'208";a="372075202"
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure
 duetomoduledependency.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
In-Reply-To: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
References: <20130716115527.GA1034@gondor.apana.org.au>
	 <201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
	 <1373991828.22432.274.camel@schen9-DESK>
	 <201307172052.EJE32506.OFMSFJQOFHtVOL@I-love.SAKURA.ne.jp>
	 <1374079597.22432.314.camel@schen9-DESK>
	 <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Jul 2013 14:53:21 -0700
Message-ID: <1374098001.22432.317.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 05:50 +0900, Tetsuo Handa wrote:
> Tim Chen wrote:
> > > Therefore, I think possible solutions are either
> > > 
> > >   (a) built-in the dependent modules
> > > 
> > >       # grep crc /lib/modules/3.11.0-rc1+/modules.dep
> > >       kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
> > >       kernel/lib/crc-t10dif.ko:
> > 
> > This approach will increase kernel size for those who are not using
> > t10dif so some people may object.  
> > BTW, The PCLMULQDQ version does not need to be build in.
> 
> sd_mod.ko must choose one from versions available as of loading sd_mod.ko.
> Although it is not needed to built-in the PCLMULQDQ version for fixing the boot
> failure, it is needed to built-in the PCLMULQDQ version for getting performance
> improvement when PCLMULQDQ is supported.
> 
> > Your approach is quite complicated.  I think something simpler like the
> > following will work:
> 
> We cannot benefit from PCLMULQDQ. Is it acceptable for you?


The following code in crct10dif-pclmul_glue.c

static const struct x86_cpu_id crct10dif_cpu_id[] = {
        X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
        {}
};
MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);

will put the module in the device table and get the module
loaded, as long as the cpu support PCLMULQDQ. So we should be able
to benefit.

Tim

