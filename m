Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaIURXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:23:36 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:49108 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIURXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:23:34 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Guenter Roeck <linux@roeck-us.net>
Date: Sun, 21 Sep 2014 19:23:26 +0200
Subject: Re: [RFC PATCH 8/8] Revert "percpu: free percpu allocation info for
 uniprocessor system"
Thread-Topic: [RFC PATCH 8/8] Revert "percpu: free percpu allocation info
 for uniprocessor system"
Thread-Index: Ac/VwMELjNOgNLYZTjmAN767OmufxQ==
Message-ID: <1C04F98F-4DA4-4038-B1D1-930BBC592147@axis.com>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
 <1411316838-15135-9-git-send-email-linux@roeck-us.net>
In-Reply-To: <1411316838-15135-9-git-send-email-linux@roeck-us.net>
Accept-Language: sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all your work with CRIS! CRISv10 is alive but is currently used as small helper CPUs close to hardware blocks.

Jesper will review and ack.

> 21 sep 2014 kl. 18:27 skrev "Guenter Roeck" <linux@roeck-us.net>:
> 
> This reverts commit 3189eddbcafcc4d827f7f19facbeddec4424eba8.
> 
> The commit causes a hang with a crisv32 image. This may be an architecture
> problem, but at least for now the revert is necessary to be able to boot a
> crisv32 image.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> mm/percpu.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index da997f9..2139e30 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1932,8 +1932,6 @@ void __init setup_per_cpu_areas(void)
> 
>    if (pcpu_setup_first_chunk(ai, fc) < 0)
>        panic("Failed to initialize percpu areas.");
> -
> -    pcpu_free_alloc_info(ai);
> }
> 
> #endif    /* CONFIG_SMP */
> -- 
> 1.9.1
> 
