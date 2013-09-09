Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3IIDD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:03:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37315 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3IIDDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <lsq.1378608721.992741360@decadent.org.uk>
References: <lsq.1378608720.401499712@decadent.org.uk>
	<lsq.1378608721.992741360@decadent.org.uk>
Date: Sun, 8 Sep 2013 23:03:53 -0400
Message-ID: <CAFB9KM0-onRXpe4bxnHkpnfxd9z1wNG9fK=haxBzm3zcEmEXtA@mail.gmail.com>
Subject: Re: [052/121] cifs: extend the buffer length enought for sprintf() using
From: Scott Lovenberg <scott.lovenberg@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jeff Layton <jlayton@redhat.com>,
        Chen Gang <gang.chen@asianux.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 10:52 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> 3.2.51-rc1 review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Chen Gang <gang.chen@asianux.com>
>
> commit 057d6332b24a4497c55a761c83c823eed9e3f23b upstream.
>
> For cifs_set_cifscreds() in "fs/cifs/connect.c", 'desc' buffer length
> is 'CIFSCREDS_DESC_SIZE' (56 is less than 256), and 'ses->domainName'
> length may be "255 + '\0'".
>
> The related sprintf() may cause memory overflow, so need extend related
> buffer enough to hold all things.
>
> It is also necessary to be sure of 'ses->domainName' must be less than
> 256, and define the related macro instead of hard code number '256'.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> Reviewed-by: Scott Lovenberg <scott.lovenberg@gmail.com>
> Signed-off-by: Steve French <smfrench@gmail.com>
> [bwh: Backported to 3.2:
>  - Adjust context in sess.c
>  - Drop inapplicable changes to connect.c]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>


Looks good to me.

-- 
Peace and Blessings,
-Scott.
