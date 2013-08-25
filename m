Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3HYQnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 12:43:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38271 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3HYQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 12:43:33 -0400
Date: Sun, 25 Aug 2013 18:43:29 +0200
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
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 17/18] Hibernate: introduced SNAPSHOT_SIG_HASH config
 for select hash algorithm
Message-ID: <20130825164329.GL5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-18-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-18-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-08-22 19:01:56, Lee, Chun-Yi wrote:
> This patch introduced SNAPSHOT_SIG_HASH config for user to select which
> hash algorithm will be used during signature generation of snapshot.
> 
> v2:
> Add define check of oCONFIG_SNAPSHOT_VERIFICATION in snapshot.c before
> declare pkey_hash().
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  kernel/power/Kconfig    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/snapshot.c |   27 ++++++++++++++++++++++-----
>  2 files changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index b592d88..79b34fa 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -78,6 +78,52 @@ config SNAPSHOT_VERIFICATION
>  	  dependent on UEFI environment. EFI bootloader should generate the
>  	  key-pair.
>  
> +choice
> +	prompt "Which hash algorithm should snapshot be signed with?"
> +        depends on SNAPSHOT_VERIFICATION
> +        help
> +          This determines which sort of hashing algorithm will be used during
> +          signature generation of snapshot. This algorithm _must_ be built into
> +	  the kernel directly so that signature verification can take place.
> +	  It is not possible to load a signed snapshot containing the algorithm
> +	  to check the signature on that module.

Like if 1000 ifdefs you already added to the code are not enough, you
make some new ones?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
