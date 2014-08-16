Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaHPApg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 20:45:36 -0400
Received: from mx12.pku.edu.cn ([162.105.129.175]:41199 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301AbaHPApf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 20:45:35 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.457
Date: Sat, 16 Aug 2014 08:45:19 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Message-ID: <207659056.258.1408149919386.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53EE6198.9010106@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_[PATCH]_unico?=
 =?utf-8?Q?re32:_Fix_build_error?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Guenter Roeck <linux@roeck-us.net> 写道：
> On 08/10/2014 08:29 AM, Guenter Roeck wrote:
> > unicore32 builds fail with
> >
> > arch/unicore32/kernel/signal.c: In function ‘setup_frame’:
> > arch/unicore32/kernel/signal.c:257: error:
> > 			‘usig’ undeclared (first use in this function)
> > arch/unicore32/kernel/signal.c:279: error:
> > 			‘usig’ undeclared (first use in this function)
> > arch/unicore32/kernel/signal.c: In function ‘handle_signal’:
> > arch/unicore32/kernel/signal.c:306: warning: unused variable ‘tsk’
> > arch/unicore32/kernel/signal.c: In function ‘do_signal’:
> > arch/unicore32/kernel/signal.c:376: error:
> > 			implicit declaration of function ‘get_signsl’
> > make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
> > make: *** [arch/unicore32/kernel/signal.o] Error 2
> >
> > Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
> > signal_setup_done()").
> >
> > This code never even compiled. Reverting the patch does not work,
> > since previously used functions no longer exist, so try to fix it up.
> > Compile tested only.
> >
> > Cc: Richard Weinberger <richard@nod.at>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> ping ...
> 
> Failure is still present in upstream kernel (v3.16-11383-gc9d2642).
> 
> Guenter
> 

Thanks. I'll fix it.

Xuetao
