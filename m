Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbaELIvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:51:35 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:51810 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaELIvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140512003201.879931356@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
	<20140512003201.879931356@1wt.eu>
Date: Mon, 12 May 2014 10:51:31 +0200
Message-ID: <CA+rthh91-GB=PPMckeDHEco=vLOimB7fBt0nVX_C+gDz3BRngg@mail.gmail.com>
Subject: Re: [ 030/143] proc connector: fix info leaks
From: Mathias Krause <minipli@googlemail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 May 2014 02:32, Willy Tarreau <w@1wt.eu> wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Mathias Krause <minipli@googlemail.com>
>
> [ Upstream commit e727ca82e0e9616ab4844301e6bae60ca7327682 ]
>
> Initialize event_data for all possible message types to prevent leaking
> kernel stack contents to userland (up to 20 bytes). Also set the flags
> member of the connector message to 0 to prevent leaking two more stack
> bytes this way.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  drivers/connector/cn_proc.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index 6069790..3a2587a 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> [...]
>  module_init(cn_proc_init);
> +       memset(&ev->event_data, 0, sizeof(ev->event_data));
> +       msg->flags = 0; /* not used */

That last hunk looks bogus. Probably the source of Christoph's compile error.

Mathias
