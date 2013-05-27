Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab3E0N5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:57:24 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34195 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3E0N5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAAG0J990rqDdG5WdOrVGqZ9tFgJmnmP18S=c6o9JNygTLHS6=g@mail.gmail.com>
References: <1366988907-13485-1-git-send-email-linus.walleij@stericsson.com>
	<CAAG0J990rqDdG5WdOrVGqZ9tFgJmnmP18S=c6o9JNygTLHS6=g@mail.gmail.com>
Date: Mon, 27 May 2013 15:57:13 +0200
Message-ID: <CACRpkda4s_Qq-R3wZ0BQSxLWm1udR4Or=h28QdEcwt6BnwEb7A@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: move subsystem mutex to pinctrl_dev struct
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 5:22 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On 26 April 2013 16:08, Linus Walleij <linus.walleij@stericsson.com> wrote:
>> @@ -608,7 +610,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
>>         bool found = false;
>>         unsigned long config;
>>
>> -       mutex_lock(&pinctrl_mutex);
>> +       mutex_lock(&pctldev->mutex);
>>
>>         /* Parse the pinctrl map and look for the elected pin/state */
>>         for_each_maps(maps_node, i, map) {
>
> This change causes an oops on v3.10-rc2 when you read pinconf-config
> because pctldev is initialised to NULL and not set until inside the
> loop.

It is taking the wrong mutex. The function right below it is
also iterating the maps, and then it shall take the maps
mutex and nothing else.

I just sent a patch fixing it up.

> If this debugfs file
> isn't meant to be specific to a pinctrl device should it be in the
> root pinctrl directory instead of in each pinctrl device's directory?

Yes. We need to fix this after this immediate fixup, for the next
merge window.

Yours,
Linus Walleij
