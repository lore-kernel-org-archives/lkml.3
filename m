Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144Ab3LBVeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:34:10 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55097 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3LBVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:34:06 -0500
X-Originating-IP: 173.246.103.110
Date: Mon, 2 Dec 2013 13:33:58 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: checkpatch not warning for some split strings
Message-ID: <20131202213358.GA15802@jtriplet-mobl1>
References: <1386019438.2680.32.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386019438.2680.32.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 01:23:58PM -0800, Joe Perches wrote:
> Hey Josh.
> 
> Back when you added commit ca56dc098ca
> ("checkpatch: check for quoted strings broken across lines")
> 
> You added this test case:
> 
>     Test case:
>     
>     void context(void)
>     {
>         struct { unsigned magic; const char *strdata; } foo[] = {
>                 { 42, "these strings"
>                       "do not produce warnings" },
>                 { 256, "though perhaps"
>                        "they should" },
>         };
> 
> which avoids emitting a warning on split strings across
> multiple lines without a function-call like '(' use on
> the line above.
> 
> Perhaps the "\(" test should be removed as checkpatch
> doesn't emit a warning for some uses like:
> 
> diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
> []
> @@ -1868,7 +1865,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
>                 /* Else poor success; go back to mode in "active" table */
>                 } else {
>                         IWL_DEBUG_RATE(mvm,
> -                                      "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
> +                                      "GOING BACK TO THE OLD TABLE: SR %d "
> +                                      "cur-tpt %d old-tpt %d\n",
>                                        window->success_ratio,
>                                        window->average_tpt,
>                                        lq_sta->last_tpt);

That one should definitely emit a warning.  However, removing the \(
test entirely will introduce warnings on many other strings embedded in
data structures; only drop that test if you've diffed the checkpatch
output for the kernel with and without it and you're comfortable with
the *huge* number of additional warnings it'll introduce.

- Josh Triplett
