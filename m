Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaKDPmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:42:52 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:19384 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaKDPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:42:49 -0500
X-CheckPoint: {5458F3F9-0-2100090A-C0000000}
Message-ID: <5458F3F8.3030100@tilera.com>
Date: Tue, 4 Nov 2014 10:42:48 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <dwalter@google.com>,
        <richard@nod.at>, Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arch: tile: kernel: signal.c: Use __copy_from/to_user()
 instead of __get/put_user()
References: <54559337.7050506@gmail.com>
In-Reply-To: <54559337.7050506@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/2014 10:13 PM, Chen Gang wrote:
> setup/restore_sigcontext() want to copy all related registers between
> user and kernel. So use block copy instead of each registers copy. Then
> can let code simple and clearer (which can avoid compiler's warning):
>
> [...]
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>   arch/tile/kernel/signal.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
> index 7c2fecc..f867783 100644
> --- a/arch/tile/kernel/signal.c
> +++ b/arch/tile/kernel/signal.c
> @@ -46,7 +46,6 @@ int restore_sigcontext(struct pt_regs *regs,
>   		       struct sigcontext __user *sc)
>   {
>   	int err = 0;
> -	int i;

Taken into the tile tree, but I removed the now-redundant initialization
of err (shown above).

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

