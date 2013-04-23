Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3DWHXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:23:12 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45416 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3DWHXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <1366699239-6866-1-git-send-email-jasowang@redhat.com>
References: <1366699239-6866-1-git-send-email-jasowang@redhat.com>
Date: Tue, 23 Apr 2013 00:23:08 -0700
Message-ID: <CAPshTCi0=pyw-s+9EQOtv7TKr13bL+Obv5QBMNB+RHEWE_FVEg@mail.gmail.com>
Subject: Re: [PATCH net] tuntap: correct the return value in tun_set_iff()
From: Jerry Chu <hkchu@google.com>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Wei Yongjun <weiyj.lk@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:40 PM, Jason Wang <jasowang@redhat.com> wrote:
> commit (3be8fbab tuntap: fix error return code in tun_set_iff()) breaks the
> creation of multiqueue tuntap since it forbids to create more than one queues
> for a multiqueue tuntap device. We need return 0 instead -EBUSY here since we
> don't want to re-initialize the device when one or more queues has been already
> attached. Add a comment and correct the return value to zero.
>
> Reported-by: Jerry Chu <hkchu@google.com>
> Cc: Jerry Chu <hkchu@google.com>
> Cc: Wei Yongjun <weiyj.lk@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/tun.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 729ed53..3a8977e 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1594,7 +1594,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>
>                 if (tun->flags & TUN_TAP_MQ &&
>                     (tun->numqueues + tun->numdisabled > 1))
> -                       return -EBUSY;
> +                       /* One or more queue has already been attached, no need
> +                        * to initialize the device again.
> +                        */
> +                       return 0;
>         }
>         else {
>                 char *name;
> --
> 1.7.1
>

Acked-by:  Jerry Chu <hkchu@google.com>
