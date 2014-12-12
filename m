Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbaLLGev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:34:51 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55251 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760767AbaLLGet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:34:49 -0500
MIME-Version: 1.0
In-Reply-To: <1418362428-15067-1-git-send-email-sasha.levin@oracle.com>
References: <1418362428-15067-1-git-send-email-sasha.levin@oracle.com>
Date: Thu, 11 Dec 2014 22:34:48 -0800
Message-ID: <CAMEtUuycug_uiK-wjVePTUmO9brMREMWPiYnEMRMdOhWBm2gjw@mail.gmail.com>
Subject: Re: [PATCH] net: sock: correctly handle failed prog retrieval from fd
From: Alexei Starovoitov <ast@plumgrid.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 9:33 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 8cc3c03..ec9baea 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1103,8 +1103,8 @@ int sk_attach_bpf(u32 ufd, struct sock *sk)
>                 return -EPERM;
>
>         prog = bpf_prog_get(ufd);
> -       if (!prog)
> -               return -EINVAL;
> +       if (IS_ERR(prog))
> +               return PTR_ERR(prog);

thank you for the fix, but the same fix is already applied
to net-next and pushed all the way to:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=198bf1b046e370a7d3987b195cff5f1efebec3ac
sorry for the headache that this bug caused.
