Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920Ab3BNUSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:18:25 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:40462 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab3BNUSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <1360196636-9357-2-git-send-email-acking@vmware.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 14 Feb 2013 15:18:02 -0500
Message-ID: <CA+1xoqfWGUuFjruFk1UV1BAXwzZvX4_i0MShQEpsq69B6P9ieg@mail.gmail.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
To: Andy King <acking@vmware.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com, kraxel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Wed, Feb 6, 2013 at 7:23 PM, Andy King <acking@vmware.com> wrote:
> + * Specifically, we initialize the vsock_bind_table array to a size of
> + * VSOCK_HASH_SIZE + 1 so that vsock_bind_table[0] through
> + * vsock_bind_table[VSOCK_HASH_SIZE - 1] are for bound sockets and
> + * vsock_bind_table[VSOCK_HASH_SIZE] is for unbound sockets.  The hash function
> + * mods with VSOCK_HASH_SIZE - 1 to ensure this.
> + */
> +#define VSOCK_HASH_SIZE         251
> +#define MAX_PORT_RETRIES        24
> +
> +#define VSOCK_HASH(addr)        ((addr)->svm_port % (VSOCK_HASH_SIZE - 1))
> +#define vsock_bound_sockets(addr) (&vsock_bind_table[VSOCK_HASH(addr)])
> +#define vsock_unbound_sockets     (&vsock_bind_table[VSOCK_HASH_SIZE])
> +
> +/* XXX This can probably be implemented in a better way. */
> +#define VSOCK_CONN_HASH(src, dst)                              \
> +       (((src)->svm_cid ^ (dst)->svm_port) % (VSOCK_HASH_SIZE - 1))
> +#define vsock_connected_sockets(src, dst)              \
> +       (&vsock_connected_table[VSOCK_CONN_HASH(src, dst)])
> +#define vsock_connected_sockets_vsk(vsk)                               \
> +       vsock_connected_sockets(&(vsk)->remote_addr, &(vsk)->local_addr)
> +
> +static struct list_head vsock_bind_table[VSOCK_HASH_SIZE + 1];
> +static struct list_head vsock_connected_table[VSOCK_HASH_SIZE];
> +static DEFINE_SPINLOCK(vsock_table_lock);

Why isn't it using the kernel's linux/hashtable.h?


Thanks,
Sasha
