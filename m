Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3DZOnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:43:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab3DZOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:43:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl: move subsystem mutex to pinctrl_dev struct
Date: Fri, 26 Apr 2013 16:43:32 +0200
Message-ID: <2852417.oyEN2DhaoE@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366794119-766-1-git-send-email-linus.walleij@stericsson.com>
References: <1366794119-766-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DCtBTbUObTRlBaQQGG0S7MNmPhZZEhbn47EmYkPgedq
 hg6pezoipdxLyMEVuraHQ80lG2zZoZAxCfnmIpXwduGi/MY4Wt
 sebT/GJBZoO5JBAGQIyK2t0FvhLf9mCPApALGxs0j/XVTTrdwG
 NqlL/SjTD11/0mrWbcdyjAVezCHj2PbIFiGPhkt4HAcUHyPBsS
 J5E8RxpeY3QB+uFvOasXPKSjnvkVKcr8aCybiEqvG0O6woHpAh
 uSuvF4p4n55Nl01oETPGDfhPaUBu3TJGFfu6kF2wW2KhB0dock
 BkMfK6Bwg2eqPucn55Al9WVd92OPwCJljCua7k7KTOYaQseS76
 VEkWDgt/8+WYVLXEQRhU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013 11:01:59 Linus Walleij wrote:
>  /**
> - * pinctrl_lookup_state() - retrieves a state handle from a pinctrl handle
> - * @p: the pinctrl handle to retrieve the state from
> - * @name: the state name to retrieve
> + * pinctrl_select_state() - select/activate/program a pinctrl state to HW
> + * @p: the pinctrl handle for the device that requests configuration
> + * @state: the state handle to select/activate/program
>   */
> -struct pinctrl_state *pinctrl_lookup_state(struct pinctrl *p, const char *name)
> -{
> -       struct pinctrl_state *s;
> -
> -       mutex_lock(&pinctrl_mutex);
> -       s = pinctrl_lookup_state_locked(p, name);
> -       mutex_unlock(&pinctrl_mutex);
> -
> -       return s;
> -}
> -EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
> -
> -static int pinctrl_select_state_locked(struct pinctrl *p,
> -                                      struct pinctrl_state *state)
> +int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>  {
>         struct p


This showed up in linux-next and broke a lot of driver modules, since you
remove the EXPORT_SYMBOL_GPL(pinctrl_lookup_state) line.

	Arnd
