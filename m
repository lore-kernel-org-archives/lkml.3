Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaJMKdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 06:33:39 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:37978
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaJMKdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 06:33:38 -0400
Date: Mon, 13 Oct 2014 12:33:37 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, eparis@redhat.com,
        sgrubb@redhat.com, aviro@redhat.com, pmoore@redhat.com,
        arozansk@redhat.com, ebiederm@xmission.com, serge@hallyn.com
Subject: Re: [PATCH V5 03/13] namespaces: expose ns_entries
Message-ID: <20141013103337.GC24703@mail.hallyn.com>
References: <cover.1412543112.git.rgb@redhat.com>
 <3ff967555ff72bf7efdf665a7209b55e4bd7f027.1412543112.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ff967555ff72bf7efdf665a7209b55e4bd7f027.1412543112.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):
> Expose ns_entries so subsystems other than proc can use this set of namespace
> operations.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/proc/namespaces.c    |    2 +-
>  include/linux/proc_ns.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> index 8902609..310da74 100644
> --- a/fs/proc/namespaces.c
> +++ b/fs/proc/namespaces.c
> @@ -15,7 +15,7 @@
>  #include "internal.h"
>  
>  
> -static const struct proc_ns_operations *ns_entries[] = {
> +const struct proc_ns_operations *ns_entries[] = {
>  #ifdef CONFIG_NET_NS
>  	&netns_operations,
>  #endif
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index aaafe3e..f4563db 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -28,6 +28,7 @@ extern const struct proc_ns_operations ipcns_operations;
>  extern const struct proc_ns_operations pidns_operations;
>  extern const struct proc_ns_operations userns_operations;
>  extern const struct proc_ns_operations mntns_operations;
> +extern const struct proc_ns_operations *ns_entries[];
>  
>  /*
>   * We always define these enumerators
> -- 
> 1.7.1
