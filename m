Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaCLU7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:59:00 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:33492 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaCLU66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <1394657163-7472-3-git-send-email-vgoyal@redhat.com>
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
	<1394657163-7472-3-git-send-email-vgoyal@redhat.com>
Date: Wed, 12 Mar 2014 13:58:57 -0700
Message-ID: <CAHA+R7OrNoa7_J-rOskxgdvkM5gAnQyoFBeCXSziY7XMd-yLNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
From: Cong Wang <cwang@twopensource.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, tj@kernel.org, ssorce@redhat.com,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 1:46 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> @@ -1098,6 +1135,16 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>         if (newsk == NULL)
>                 goto out;
>
> +       err = init_peercgroup(newsk);
> +       if (err)
> +               goto out;
> +
> +       err = alloc_cgroup_path(sk);
> +       if (err)
> +               goto out;
> +
> +       err = -ENOMEM;
> +

Don't we need to free the cgroup_path on error path
in this function?
