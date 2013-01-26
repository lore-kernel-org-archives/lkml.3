Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3AZVLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:11:21 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:35797 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3AZVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:11:19 -0500
Date: Sat, 26 Jan 2013 21:13:12 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control
 groups.
Message-ID: <20130126211312.GD11274@mail.hallyn.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87txq4hedl.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txq4hedl.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> In the help text describing user namespaces recommend use of memory
> control groups.  In many cases memory control groups are the only
> mechanism there is to limit how much memory a user who can create
> user namespaces can use.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

nit:

> ---
>  Documentation/namespaces/resource-control.txt |   10 ++++++++++
>  init/Kconfig                                  |    7 +++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/namespaces/resource-control.txt
> 
> diff --git a/Documentation/namespaces/resource-control.txt b/Documentation/namespaces/resource-control.txt
> new file mode 100644
> index 0000000..3d8178a
> --- /dev/null
> +++ b/Documentation/namespaces/resource-control.txt
> @@ -0,0 +1,10 @@
> +There are a lot of kinds of objects in the kernel that don't have
> +individual limits or that have limits that are ineffective when a set
> +of processes is allowed to switch user ids.  With user namespaces
> +enabled in a kernel for people who don't trust their users or their
> +users programs to play nice this problems becomes more acute.

users' programs

> +
> +Therefore it is recommended that memory control groups be enabled in
> +kernels that enable user namespaces, and it is further recommended
> +that userspace configure memory control groups to limit how much
> +memory users they don't trust to play nice can use.
> diff --git a/init/Kconfig b/init/Kconfig
> index 7d30240..c8c58bd 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1035,6 +1035,13 @@ config USER_NS
>  	help
>  	  This allows containers, i.e. vservers, to use user namespaces
>  	  to provide different user info for different servers.
> +
> +	  When user namespaces are enabled in the kernel it is
> +	  recommended that the MEMCG and MEMCG_KMEM options also be
> +	  enabled and that user-space use the memory control groups to
> +	  limit the amount of memory a memory unprivileged users can
> +	  use.
> +
>  	  If unsure, say N.
>  
>  config PID_NS
> -- 
> 1.7.5.4
