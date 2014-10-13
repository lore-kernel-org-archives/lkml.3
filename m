Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaJMMaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:30:17 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:39623
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbaJMMaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:30:13 -0400
Date: Mon, 13 Oct 2014 14:30:11 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        sgrubb@redhat.com, aviro@redhat.com, pmoore@redhat.com,
        arozansk@redhat.com, ebiederm@xmission.com, serge@hallyn.com
Subject: Re: [PATCH V5 05/13] audit: initialize at subsystem time rather than
 device time
Message-ID: <20141013123011.GF24703@mail.hallyn.com>
References: <cover.1412543112.git.rgb@redhat.com>
 <7fda57304bb2f74ccb7f610c04df6aa0c04bf4ba.1412543112.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fda57304bb2f74ccb7f610c04df6aa0c04bf4ba.1412543112.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):
> The audit subsystem should be initialized a bit earlier so that it is in place
> in time for initial namespace serial number logging.
> ---

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

>  kernel/audit.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index ff1630d..8ff7f28 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1186,7 +1186,7 @@ static int __init audit_init(void)
>  
>  	return 0;
>  }
> -__initcall(audit_init);
> +subsys_initcall(audit_init);
>  
>  /* Process kernel command-line parameter at boot time.  audit=0 or audit=1. */
>  static int __init audit_enable(char *str)
> -- 
> 1.7.1
