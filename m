Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaILW25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:28:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:48694 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaILW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:28:56 -0400
MIME-Version: 1.0
In-Reply-To: <1410430968.32479.2.camel@phoenix>
References: <1410430870.32479.0.camel@phoenix>
	<1410430968.32479.2.camel@phoenix>
Date: Fri, 12 Sep 2014 15:28:55 -0700
X-Google-Sender-Auth: foZP5wWchGI1Y0m2RD1HpKsNTAk
Message-ID: <CAD=FV=WOUPcsQ76MG1poDAK=UQeg3uxN_Ci_akH=4JVqNvUx9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: rk808: Fix missing of_node_put
From: Doug Anderson <dianders@chromium.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel,

On Thu, Sep 11, 2014 at 3:22 AM, Axel Lin <axel.lin@ingics.com> wrote:
> 1. Pass &pdev->dev rather than &client->dev to of_regulator_match, the *dev
>    argument is used for devres to ensure devm_of_regulator_put_matches() will
>    be called when unload the module.
>
> 2. of_get_child_by_name() returns a node pointer with refcount incremented.
>    Thus add missing of_node_put(reg_np).
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/rk808-regulator.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

I've tested that things still work fine after applying this patch and
confirmed both of your statements are true to the best of my
knowledge.  I haven't tested module removal (which is where some of
this matters) but what's here looks good.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

-Doug
