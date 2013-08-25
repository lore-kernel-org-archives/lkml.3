Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3HYQOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 12:14:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3HYQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 12:14:31 -0400
Date: Sun, 25 Aug 2013 18:14:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 08/18] Secure boot: Add new capability
Message-ID: <20130825161428.GE5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-9-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-9-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-08-22 19:01:47, Lee, Chun-Yi wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> Secure boot adds certain policy requirements, including that root must not
> be able to do anything that could cause the kernel to execute arbitrary code.
> The simplest way to handle this would seem to be to add a new capability
> and gate various functionality on that. We'll then strip it from the initial
> capability set if required.

There was some discussion about this before, right? And I don't think
conclusion was it was acceptable...?

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Acked-by: Lee, Chun-Yi <jlee@suse.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  include/uapi/linux/capability.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index ba478fa..7109e65 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -343,7 +343,11 @@ struct vfs_cap_data {
>  
>  #define CAP_BLOCK_SUSPEND    36
>  
> -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
> +/* Allow things that trivially permit root to modify the running kernel */
> +
> +#define CAP_COMPROMISE_KERNEL  37
> +
> +#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
