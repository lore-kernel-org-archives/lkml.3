Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3H2NhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:37:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3H2NhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:37:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RFC v2 14/16] ARM: vexpress: remove custom .init_time hook
Date: Thu, 29 Aug 2013 15:35:52 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-15-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1377638890-371-15-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291535.53005.arnd@arndb.de>
X-Provags-ID: V02:K0:ejA0XdJcXpoCwHRUBd9f+eIbXOdOnTbkWG/mUNF17pD
 mxBLNt3qMgjc5gxWOh7j9LTTnN+6wGsCkde1kgJP/lSr6VGcjs
 nr+V6Rc1D5HpK5ssYZyux4LYcJVFSq6xJyhtMA/5lWjRjkhmUx
 /fHeAUXxnghsLL5e8hW/buV2mmk8NJVIKqo1PTZefULZp+arxG
 daiW/jCcQujYZqUKdDb9KIw5vhRgwWVAOPtIWOCjjHA4qhhDrW
 gDN8aI8EJFXqU70lgB1p8TWhXrWcWNXG/OjU46qXO9vZ5j54N+
 x11/HUnrhRD2bMXvAeLlgS5zfuMpsb5OZrjrVoKj9qtc1964oY
 Tz3ydKac/n7kmRxIQLL0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
> @@ -422,16 +419,8 @@ void __init v2m_dt_init_early(void)
>                         pr_warning("vexpress: DT HBI (%x) is not matching "
>                                         "hardware (%x)!\n", dt_hbi, hbi);
>         }
> -}
> -
> -static void __init v2m_dt_timer_init(void)
> -{
> -       of_clk_init(NULL);
>  
> -       clocksource_of_init();
> -
> -       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
> -                               24000000);
> +       versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
>  }


You are moving versatile_sched_clock_init() ahead of clocksource_of_init(), which I suspect
won't work. Have you checked this?

	Arnd
