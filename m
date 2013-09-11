Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3IKXnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 19:43:15 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:41395 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753597Ab3IKXnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 19:43:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:151
X-HE-Tag: list48_8fd631f690c4d
X-Filterd-Recvd-Size: 3132
Message-ID: <1378942983.4714.40.camel@joe-AO722>
Subject: Re: [RFC PATCH] vsnprintf: Remove use of %n and convert existing
 uses
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org
Date: Wed, 11 Sep 2013 16:43:03 -0700
In-Reply-To: <CAGXu5jLyCGuSRqEGCSw=VrrOvOr=aAok6ZZTAj_qmDA3CbmLww@mail.gmail.com>
References: <20130911044116.GA17294@www.outflux.net>
	 <1378875632.606.5.camel@joe-AO722>
	 <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
	 <20130911093118.GD25896@mwanda>
	 <CAGXu5j+H_RLwj9c6CKxMpaYeR9kS-qDnK+e1mOHHt9zh6vAm=w@mail.gmail.com>
	 <1378926562.4714.11.camel@joe-AO722>
	 <CAGXu5jLO6109fkejXqX=WhkQnfAUeWtTcow0v1BNqyi=8=Qa3Q@mail.gmail.com>
	 <1378928700.4714.17.camel@joe-AO722>
	 <CAGXu5jLTjrPr=GwOmMcu55Qp9K-_XS75xq9NJ0vBUEwy-i_YMw@mail.gmail.com>
	 <1378941761.4714.37.camel@joe-AO722>
	 <CAGXu5jLyCGuSRqEGCSw=VrrOvOr=aAok6ZZTAj_qmDA3CbmLww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 16:29 -0700, Kees Cook wrote:
> On Wed, Sep 11, 2013 at 4:22 PM, Joe Perches <joe@perches.com> wrote:
> > Using vsnprintf or its derivatives with %n can have security
> > vulnerability implications.
> >
> > Prior to commit fef20d9c1380
> > ("vsprintf: unify the format decoding layer for its 3 users"),
> > any use of %n was ignored.
> >
> > Reintroduce this feature and convert the existing uses of %n
> > to use the return length from vsnprintf or its derivatives.
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> (proc bits)
> > cc: Kees Cook <keescook@chromium.org>
> > cc: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Yes, please. It might also be worth updating
> Documentation/printk-formats.txt to mention that %n has intentionally
> removed and will be ignored.

Fine with me if you want to update that file.

It doesn't currently try to be a complete man page
for vsnprintf though.

vsprintf.c does have kernel-doc documentation and
that already does show that %n is ignored.


