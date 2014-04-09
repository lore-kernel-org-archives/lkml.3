Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaDILQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:16:22 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:44563 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462AbaDILQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:16:18 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH 1/1] NTFS: Remove NULL value assignments
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20140408221201.492b38bb74c3fb3ee33403ce@skynet.be>
Date: Wed, 9 Apr 2014 12:16:12 +0100
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <52123238-E2F0-4D2D-A2AF-C8AAA79024C9@tuxera.com>
References: <20140408221201.492b38bb74c3fb3ee33403ce@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

Thanks.  Looks good, but why leave the "static ... = 0;" cases if you are doing the NULL ones?

Do you feel like redoing it to cover the = 0 cases as well?

Anyway, you can add my Acked-By line.

Best regards,

	Anton

On 8 Apr 2014, at 21:12, Fabian Frederick <fabf@skynet.be> wrote:

> Static values are automatically initialized to NULL.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Anton Altaparmakov <anton@tuxera.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> fs/ntfs/compress.c | 2 +-
> fs/ntfs/super.c    | 2 +-
> fs/ntfs/sysctl.c   | 2 +-
> 3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index ee4144c..f82498c 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -58,7 +58,7 @@ typedef enum {
> /**
>  * ntfs_compression_buffer - one buffer for the decompression engine
>  */
> -static u8 *ntfs_compression_buffer = NULL;
> +static u8 *ntfs_compression_buffer;
> 
> /**
>  * ntfs_cb_lock - spinlock which protects ntfs_compression_buffer
> diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> index 9de2491..eed5119 100644
> --- a/fs/ntfs/super.c
> +++ b/fs/ntfs/super.c
> @@ -50,7 +50,7 @@
> static unsigned long ntfs_nr_compression_users;
> 
> /* A global default upcase table and a corresponding reference count. */
> -static ntfschar *default_upcase = NULL;
> +static ntfschar *default_upcase;
> static unsigned long ntfs_nr_upcase_users = 0;
> 
> /* Error constants/strings used in inode.c::ntfs_show_options(). */
> diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
> index 79a8918..1927170 100644
> --- a/fs/ntfs/sysctl.c
> +++ b/fs/ntfs/sysctl.c
> @@ -56,7 +56,7 @@ static ctl_table sysctls_root[] = {
> };
> 
> /* Storage for the sysctls header. */
> -static struct ctl_table_header *sysctls_root_table = NULL;
> +static struct ctl_table_header *sysctls_root_table;
> 
> /**
>  * ntfs_sysctl - add or remove the debug sysctl
> -- 
> 1.8.4.5

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

