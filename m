Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3CJOOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 10:14:04 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64307 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3CJOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 10:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <1362921205-10295-1-git-send-email-steliannirlu@gmail.com>
References: <1362921205-10295-1-git-send-email-steliannirlu@gmail.com>
Date: Sun, 10 Mar 2013 16:14:00 +0200
X-Google-Sender-Auth: wJLEIfVMvYBH7boHVL0jF1UJOxk
Message-ID: <CAOJsxLGZ=6r85D5OBrFehbpjVSTvK-vaMGQGD9W0ssymT4QyTw@mail.gmail.com>
Subject: Re: [PATCH] s390: replace kmalloc + memset with kzalloc
From: Pekka Enberg <penberg@kernel.org>
To: Stelian Nirlu <steliannirlu@gmail.com>
Cc: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 3:13 PM, Stelian Nirlu <steliannirlu@gmail.com> wrote:
> Signed-off-by: Stelian Nirlu <steliannirlu@gmail.com>
> ---
>  arch/s390/net/bpf_jit_comp.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
> index 0972e91..e645528 100644
> --- a/arch/s390/net/bpf_jit_comp.c
> +++ b/arch/s390/net/bpf_jit_comp.c
> @@ -747,10 +747,9 @@ void bpf_jit_compile(struct sk_filter *fp)
>
>         if (!bpf_jit_enable)
>                 return;
> -       addrs = kmalloc(fp->len * sizeof(*addrs), GFP_KERNEL);
> +       addrs = kzalloc(fp->len * sizeof(*addrs), GFP_KERNEL);

kcalloc() might be more appropriate here to protect against integer
overflow if "fp->len" is too large.
