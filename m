Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3GQUuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:50:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57858 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3GQUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:50:16 -0400
X-Nat-Received: from [202.181.97.72]:59357 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1374094207.28244
To: tim.c.chen@linux.intel.com
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure duetomoduledependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130716115527.GA1034@gondor.apana.org.au>
	<201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
	<1373991828.22432.274.camel@schen9-DESK>
	<201307172052.EJE32506.OFMSFJQOFHtVOL@I-love.SAKURA.ne.jp>
	<1374079597.22432.314.camel@schen9-DESK>
In-Reply-To: <1374079597.22432.314.camel@schen9-DESK>
Message-Id: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 18 Jul 2013 05:50:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17072013 #10618882, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Chen wrote:
> > Therefore, I think possible solutions are either
> > 
> >   (a) built-in the dependent modules
> > 
> >       # grep crc /lib/modules/3.11.0-rc1+/modules.dep
> >       kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
> >       kernel/lib/crc-t10dif.ko:
> 
> This approach will increase kernel size for those who are not using
> t10dif so some people may object.  
> BTW, The PCLMULQDQ version does not need to be build in.

sd_mod.ko must choose one from versions available as of loading sd_mod.ko.
Although it is not needed to built-in the PCLMULQDQ version for fixing the boot
failure, it is needed to built-in the PCLMULQDQ version for getting performance
improvement when PCLMULQDQ is supported.

> Your approach is quite complicated.  I think something simpler like the
> following will work:

We cannot benefit from PCLMULQDQ. Is it acceptable for you?
