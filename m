Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaLRWMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:12:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaLRWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:12:50 -0500
Date: Thu, 18 Dec 2014 14:12:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] stable_kernel_rules: reorganize and update submission
 options
Message-ID: <20141218221249.GA10229@kroah.com>
References: <1418886676-27036-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418886676-27036-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:11:16PM -0800, Brian Norris wrote:
> The current organization of Documentation/stable_kernel_rules.txt
> doesn't clearly differentiate the mutually exclusive options for
> submission to the -stable review process. As I understand it, patches
> are not actually required to be mailed directly to
> stable@vger.kernel.org, but the instructions do not make this clear.
> 
> Also, there are some established processes that are not listed --
> specifically, what I call Option 2 below.
> 
> This patch updates and reorganizes a bit, to make things clearer.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
> This patch brough to you as a follow-up of:
> 
>   https://lkml.org/lkml/2014/9/5/757
> 
> I don't profess to know your mind, Greg, but this is my attempt at codifying
> what I've observed.
> 
>  Documentation/stable_kernel_rules.txt | 42 ++++++++++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
> index aee73e78c7d4..a34adcb462b0 100644
> --- a/Documentation/stable_kernel_rules.txt
> +++ b/Documentation/stable_kernel_rules.txt
> @@ -32,18 +32,40 @@ Procedure for submitting patches to the -stable tree:
>   - If the patch covers files in net/ or drivers/net please follow netdev stable
>     submission guidelines as described in
>     Documentation/networking/netdev-FAQ.txt
> - - Send the patch, after verifying that it follows the above rules, to
> -   stable@vger.kernel.org.  You must note the upstream commit ID in the
> -   changelog of your submission, as well as the kernel version you wish
> -   it to be applied to.
> - - To have the patch automatically included in the stable tree, add the tag
> + - Security patches should not be handled (solely) by the -stable review
> +   process but should follow the procedures in Documentation/SecurityBugs.
> +
> +For all other submissions, choose one of the following procedures:
> +
> +   --- Option 1 ---
> +
> +   To have the patch automatically included in the stable tree, add the tag
>       Cc: stable@vger.kernel.org
>     in the sign-off area. Once the patch is merged it will be applied to
>     the stable tree without anything else needing to be done by the author
>     or subsystem maintainer.
> - - If the patch requires other patches as prerequisites which can be
> -   cherry-picked, then this can be specified in the following format in
> -   the sign-off area:
> +
> +   --- Option 2 ---
> +
> +   Send an email to stable@vger.kernel.org that just contains the commit ID
> +   of the patch -- after it has been merged to Linus' tree, of course.

"just" should also have at least the subject of the patch, why you think
it should be applied, and what kernel version you wish it to be applied
to.

> +
> +   --- Option 3 ---
> +
> +   Send the patch, after verifying that it follows the above rules, to
> +   stable@vger.kernel.org.  You must note the upstream commit ID in the
> +   changelog of your submission, as well as the kernel version you wish
> +   it to be applied to.
> +
> +Option 1 is probably the easiest and most common. Options 2 and 3 are more
> +useful if the patch isn't deemed worthy at the time it is applied to a public
> +git tree (for instance, because it deserves more regression testing first).
> +Option 3 is especially useful if the patch needs some special handling to apply
> +to an older kernel (e.g., if API's have changed in the meantime).
> +
> +Additionally, some patches submitted via Option 1 may have additional patch
> +prerequisites which can be cherry-picked. This can be specified in the following
> +format in the sign-off area:
>  
>       Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
>       Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
> @@ -57,13 +79,13 @@ Procedure for submitting patches to the -stable tree:
>       git cherry-pick fd21073
>       git cherry-pick <this commit>
>  
> +Following the submission:
> +
>   - The sender will receive an ACK when the patch has been accepted into the
>     queue, or a NAK if the patch is rejected.  This response might take a few
>     days, according to the developer's schedules.
>   - If accepted, the patch will be added to the -stable queue, for review by
>     other developers and by the relevant subsystem maintainer.
> - - Security patches should not be sent to this alias, but instead to the
> -   documented security@kernel.org address.

Other than the above comments, this looks good, care to redo it?

thanks,

greg k-h
