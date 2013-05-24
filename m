Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3EXPWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:22:34 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:41951 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3EXPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:22:32 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <1366988907-13485-1-git-send-email-linus.walleij@stericsson.com>
References: <1366988907-13485-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 24 May 2013 16:22:31 +0100
X-Google-Sender-Auth: 1NHbem3O49AXqPsig3_F3bGv59s
Message-ID: <CAAG0J990rqDdG5WdOrVGqZ9tFgJmnmP18S=c6o9JNygTLHS6=g@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: move subsystem mutex to pinctrl_dev struct
From: James Hogan <james.hogan@imgtec.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Patrice Chotard <patrice.chotard@st.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 16:08, Linus Walleij <linus.walleij@stericsson.com> wrote:
> @@ -608,7 +610,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
>         bool found = false;
>         unsigned long config;
>
> -       mutex_lock(&pinctrl_mutex);
> +       mutex_lock(&pctldev->mutex);
>
>         /* Parse the pinctrl map and look for the elected pin/state */
>         for_each_maps(maps_node, i, map) {

This change causes an oops on v3.10-rc2 when you read pinconf-config
because pctldev is initialised to NULL and not set until inside the
loop. I considered initialising pctldev to s->private, but I'm
concerned that if pctldev is altered in the loop it could end up
unlocking a different mutex to the one it locked. If this debugfs file
isn't meant to be specific to a pinctrl device should it be in the
root pinctrl directory instead of in each pinctrl device's directory?

Cheers
James
