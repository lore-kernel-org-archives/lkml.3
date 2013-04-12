Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab3DLNcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:32:52 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45982 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3DLNcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:32:51 -0400
Date: Fri, 12 Apr 2013 09:32:48 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: yongjun wei <yongjun_wei@trendmicro.com.cn>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <951128173.20228549.1365773568016.JavaMail.root@redhat.com>
In-Reply-To: <A360F954C61C69449463B0606663711259EE4EBC@CDCEXMBX01.tw.trendnet.org>
References: <CAPgLHd-M-q-xf+mp3VTAabxXS3bOjZ4g8EWLeE2NdjC2O7qCSA@mail.gmail.com> <170253117.11083340.1365614765343.JavaMail.root@redhat.com> <A360F954C61C69449463B0606663711259EE4EBC@CDCEXMBX01.tw.trendnet.org>
Subject: Re: [PATCH -next] audit: remove duplicated include from audit.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: [PATCH -next] audit: remove duplicated include from audit.c
Thread-Index: Ac43Lc94QGubB33dQHGvphSp1r0KFsUijZq7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Came in via the net-next tree from commit 941912133025926307c7a65b203fa38403b1063a

I'll ping dmiller and friends.

----- Original Message -----
> Hi Eric,
> 
> Sorry reply on top.
> 
> From the source code from linex-next.git tree, line 55~64:
> 
> #include <net/sock.h>
> #include <net/netlink.h>            *******
> #include <linux/skbuff.h>
> #ifdef CONFIG_SECURITY
> #include <linux/security.h>
> #endif
> #include <net/netlink.h>            *******
> #include <linux/freezer.h>
> #include <linux/tty.h>
> #include <linux/pid_namespace.h>
> 
> net/netlink.h is included twice, and linux/netlink.h is not included by this
> file.
> 
> -----Original Message-----
> From: Eric Paris [mailto:eparis@redhat.com]
> Sent: 2013年4月11日 1:26
> To: Wei Yongjun
> Cc: viro@zeniv.linux.org.uk; Yongjun Wei (RD-CN);
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH -next] audit: remove duplicated include from audit.c
> 
> net/netlink.h includes linux/netlink.h but linux/netlink.h does not include
> net/netlink.h
> 
> since the audit code uses the nlmsg_* functions provided in net/netlink.h it
> seems we need this include.
> 
> since the audit code uses netlink_unicast provided in linux/netlink.h it
> seems we need that include.
> 
> I don't see duplication even if by chance one of them would have included the
> other...
> 
> ----- Original Message -----
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Remove duplicated include.
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  kernel/audit.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/kernel/audit.c b/kernel/audit.c index 488f85f..9377913
> > 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -58,7 +58,6 @@
> >  #ifdef CONFIG_SECURITY
> >  #include <linux/security.h>
> >  #endif
> > -#include <net/netlink.h>
> >  #include <linux/freezer.h>
> >  #include <linux/tty.h>
> >  #include <linux/pid_namespace.h>
> > 
> > 
> 
> <table class="TM_EMAIL_NOTICE"><tr><td><pre>
> TREND MICRO EMAIL NOTICE
> The information contained in this email and any attachments is confidential
> and may be subject to copyright or other intellectual property protection.
> If you are not the intended recipient, you are not authorized to use or
> disclose this information, and we request that you notify us by reply mail or
> telephone and delete the original message from your mail system.
> </pre></td></tr></table>
