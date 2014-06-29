Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaF2AqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 20:46:22 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:50153 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaF2AqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 20:46:21 -0400
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2014 20:46:20 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] ntfs: Drop cast
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <anton@tuxera.com>
In-Reply-To: <20140628133302.GA4722@himangi-Dell>
Date: Sun, 29 Jun 2014 01:30:37 +0100
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Content-Transfer-Encoding: 8BIT
Message-Id: <D8693164-70F0-4BBB-94DA-C471EF43AB90@tuxera.com>
References: <20140628133302.GA4722@himangi-Dell>
To: Himangi Saraogi <himangi774@gmail.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your patch.  Your patch is obviously correct however I actually prefer to have the type casts in place because it clearly shows what the variable type being assigned to is so I find it makes the code more readable to cast void pointers to the target variable type so I don't have to go and look up the type higher up.  Having said that I don't feel that strongly about it so I have no real objection to the patch getting applied...

Best regards,

	Anton

On 28 Jun 2014, at 14:33, Himangi Saraogi <himangi774@gmail.com> wrote:

> This patch removes the cast on data of type void * as it is not needed.
> The following Coccinelle semantic patch was used for making the change:
> 
> @r@
> expression x;
> void* e;
> type T;
> identifier f;
> @@
> 
> (
>  *((T *)e)
> |
>  ((T *)x)[...]
> |
>  ((T *)x)->f
> |
> - (T *)
>  e
> )
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> fs/ntfs/inode.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
> index f47af5e..b3c55fc 100644
> --- a/fs/ntfs/inode.c
> +++ b/fs/ntfs/inode.c
> @@ -1817,7 +1817,7 @@ int ntfs_read_inode_mount(struct inode *vi)
> 	i = vol->mft_record_size;
> 	if (i < sb->s_blocksize)
> 		i = sb->s_blocksize;
> -	m = (MFT_RECORD*)ntfs_malloc_nofs(i);
> +	m = ntfs_malloc_nofs(i);
> 	if (!m) {
> 		ntfs_error(sb, "Failed to allocate buffer for $MFT record 0.");
> 		goto err_out;

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

