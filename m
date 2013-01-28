Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3A1HhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:37:08 -0500
Received: from mx2.parallels.com ([64.131.90.16]:52838 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab3A1HhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:37:06 -0500
Message-ID: <51062AB5.9060203@parallels.com>
Date: Mon, 28 Jan 2013 11:37:25 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control groups.
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com>
In-Reply-To: <87txq4hedl.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2013 06:22 AM, Eric W. Biederman wrote:
> 
> In the help text describing user namespaces recommend use of memory
> control groups.  In many cases memory control groups are the only
> mechanism there is to limit how much memory a user who can create
> user namespaces can use.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
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

Since this becomes an official recommendation that people will likely
follow, are we really that much concerned about the types of abuses the
MEMCG_KMEM will prevent? Those are mostly metadata-based abuses users
could do in their own local disks without mounting anything extra (and
things that look like that)

Unless there is a specific concern here, shouldn't we say "... that the
MEMCG (and possibly MEMCG_KMEM) options..." ?


