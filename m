Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3B0KBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:01:40 -0500
Received: from intranet.asianux.com ([58.214.24.6]:35721 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3B0KBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:01:38 -0500
X-Spam-Score: -100.8
Message-ID: <512DD96C.5060001@asianux.com>
Date: Wed, 27 Feb 2013 18:01:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        "netdev@vger.kernel.org >> netdev" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/ath/wil6210: Makefile, only -Werror
 when no -W* in EXTRA_CFLAGS
References: <512DADCA.9040609@asianux.com> <1385870.TegBXpTM9i@lx-vladimir> <512DCA59.4040800@asianux.com> <1921426.IqHmmMU5eP@lx-vladimir>
In-Reply-To: <1921426.IqHmmMU5eP@lx-vladimir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月27日 17:46, Vladimir Kondratiev 写道:
> Perhaps, it would be good idea to fight the original problem.
> 

  if my another 'beautify code' patches are applied into next-* tree.
    (that means most of members think it is a good idea).
    I will process the original problems (when processing, also cc to you).

  :-)

> I mean, fix warnings where possible. Example: there are lots of
> "unused parameter" ones. Where it is false warning, add __maybe_unused
> attribute. Like this:
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index c566927..83e43b7 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -163,8 +163,9 @@ extern int _cond_resched(void);
>  # define might_sleep() \
>         do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
>  #else
> -  static inline void __might_sleep(const char *file, int line,
> -                                  int preempt_offset) { }
> +  static inline void __might_sleep(const char *file __maybe_unused,
> +                                  int line __maybe_unused,
> +                                  int preempt_offset __maybe_unused) { }
>  # define might_sleep() do { might_resched(); } while (0)
>  #endif
>  

  thank you for your demo, it is valuable to me.

  :-)


-- 
Chen Gang

Asianux Corporation
