Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaBLQkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:40:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaBLQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:40:41 -0500
Date: Wed, 12 Feb 2014 08:41:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Tools: hv: vssdaemon: Ignore VFAT mounts during the
 Freeze operation
Message-ID: <20140212164157.GC22377@kroah.com>
References: <1392223222-18037-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392223222-18037-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 08:40:22AM -0800, K. Y. Srinivasan wrote:
> If the guest has a FAT file system mounted, skip it during the FREEZE
> operation. With this change we can support host initiated backup of
> the guest even when the guest may have FAT file systems mounted.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_vss_daemon.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 520de3304..6a213b8 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -87,6 +87,8 @@ static int vss_operate(int operation)
>  			continue;
>  		if (strcmp(ent->mnt_type, "iso9660") == 0)
>  			continue;
> +		if (strcmp(ent->mnt_type, "vfat") == 0)
> +			continue;

Why should the filesystem type matter here at all?

thanks,

greg k-h
