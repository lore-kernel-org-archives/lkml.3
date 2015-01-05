Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbAEJYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:24:54 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:53183 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbbAEJYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:24:52 -0500
Message-ID: <1420449884.1898.3.camel@sipsolutions.net>
Subject: Re: [PATCH] rfkill: parameters documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Clausen <andrew.p.clausen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 10:24:44 +0100
In-Reply-To: <CAAXZBWLOKL8Uu9No_tQga34nFurmeK2HP9qixO1jCXw1Y0t5HA@mail.gmail.com> (sfid-20150102_200110_665438_46A7C2C9)
References: <CAAXZBWLOKL8Uu9No_tQga34nFurmeK2HP9qixO1jCXw1Y0t5HA@mail.gmail.com>
	 (sfid-20150102_200110_665438_46A7C2C9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-02 at 19:01 +0000, Andrew Clausen wrote:
> Hi all,
> 
> This patch documents two rfkill module parameters, namely
> rfkill.default_state and rfkill.master_switch_mode.
> 
> I constructed the patch from Ubuntu packaged source, but I'm happy to
> adapt it to any git tree.
> 
> Kind regards,
> Andrew
> 
> Signed-off-by: Andrew Clausen <andrew.p.clausen@gmail.com>

Looks fine to me (though the commit message shouldn't contain the email
"boilerplate" of "hi all" etc - should just be

rfkill: document module parameters

Document the two rfkill module parameters "default_state" and
"master_switch_mode".

Signed-off-by: ...


However I'm not sure I should apply this through my tree?

johannes

> ---
> 
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt
> index 011855b..824ee3b 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2999,6 +2999,20 @@ bytes respectively. Such letter suffixes can
> also be entirely omitted.
> 
>      retain_initrd    [RAM] Keep initrd memory after extraction
> 
> +    rfkill.default_state=
> +        0        "airplane mode".  All wifi, bluetooth, wimax,
> +                gps, fm, etc. communication is blocked by
> +                default.
> +        1        Unblocked.
> +
> +    rfkill.master_switch_mode=
> +        0        The "airplane mode" button does nothing.
> +        1        The "airplane mode" button toggles between
> +                everything blocked and the previous
> +                configuration.
> +        2        The "airplane mode" button toggles between
> +                everything blocked and everything unblocked.
> +
>      rhash_entries=    [KNL,NET]
>              Set number of hash buckets for route cache
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index 427e897..2ee6ef9 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -25,6 +25,9 @@ whether they can be changed or not:
>   - soft block: writable radio block (need not be readable) that is set by
>                 the system software.
> 
> +The rfkill subsystem has two parameters, rfkill.default_state and
> +rfkill.master_switch_mode, which are documented in kernel-parameters.txt.
> +
> 
>  2. Implementation details
> 


