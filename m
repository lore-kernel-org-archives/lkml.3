Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaBDTU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:20:26 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33503 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaBDTUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:20:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAHA+R7Omv++NCg=nocVsW+tM=Zv_qCNhX1JjtFTuCzfz9B3Cig@mail.gmail.com>
References: <CAMuHMdVCeFek2LX0_AnA8zg_yYhXvzw19rH8OsqbWWb-rb9w-A@mail.gmail.com>
	<CAHA+R7Omv++NCg=nocVsW+tM=Zv_qCNhX1JjtFTuCzfz9B3Cig@mail.gmail.com>
Date: Tue, 4 Feb 2014 20:20:20 +0100
X-Google-Sender-Auth: psEAw3wi17gRKPWDp9xywt0svNI
Message-ID: <CAMuHMdWUR-x=fwG26xg8AsUQwL+FXLaQAnkaWHbrVaep0QzHJQ@mail.gmail.com>
Subject: Re: [bisected] Re: WARNING: at net/ipv4/devinet.c:1599
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Cong Wang <cwang@twopensource.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 7:08 PM, Cong Wang <cwang@twopensource.com> wrote:
> On Tue, Feb 4, 2014 at 6:19 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>> Anyone with a clue?
>>
>
> Looks like we need:
>
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index ac2dff3..bdbf68b 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1443,7 +1443,8 @@ static size_t inet_nlmsg_size(void)
>                + nla_total_size(4) /* IFA_LOCAL */
>                + nla_total_size(4) /* IFA_BROADCAST */
>                + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
> -              + nla_total_size(4);  /* IFA_FLAGS */
> +              + nla_total_size(4)  /* IFA_FLAGS */
> +              + nla_total_size(sizeof(struct ifa_cacheinfo)); /*
> IFA_CACHEINFO */
>  }

Thanks for your suggestion, but it doesn't help :-(

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
