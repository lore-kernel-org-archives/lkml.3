Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3ASI6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 03:58:36 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37394 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3ASI6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 03:58:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130116165239.GB18593@gmail.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
	<20130116113522.GR11529@redhat.com>
	<20130116165239.GB18593@gmail.com>
Date: Sat, 19 Jan 2013 10:58:33 +0200
X-Google-Sender-Auth: T9m6TkUnlXcav-U66rlQDZkDwtY
Message-ID: <CAOJsxLFHhKLxNcjwUO-tFrjZ5MYFhWdgBX-LHSkh28-SX1cE4Q@mail.gmail.com>
Subject: Re: [PATCH v2] kvm tools: remove redundant "if" condition
From: Pekka Enberg <penberg@kernel.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 6:52 PM, Cong Ding <dinggnu@gmail.com> wrote:
> After we check (state.kcount != 0), state.kcount has to be 0 in all the "else"
> branchs.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  tools/kvm/hw/i8042.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/kvm/hw/i8042.c b/tools/kvm/hw/i8042.c
> index 9f8be6a..9035732 100644
> --- a/tools/kvm/hw/i8042.c
> +++ b/tools/kvm/hw/i8042.c
> @@ -189,7 +189,7 @@ static u32 kbd_read_data(void)
>                 state.mcount--;
>                 kvm__irq_line(state.kvm, AUX_IRQ, 0);
>                 kbd_update_irq();
> -       } else if (state.kcount == 0) {
> +       } else {
>                 i = state.kread - 1;
>                 if (i < 0)
>                         i = QUEUE_SIZE;

This doesn't look right. The 'kcount' field is an int so the value can
be negative.
