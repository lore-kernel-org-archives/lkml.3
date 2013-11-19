Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab3KSS3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:29:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3KSS3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:29:05 -0500
Date: Tue, 19 Nov 2013 10:29:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 1/9] staging/lustre/llite: Access to released file trigs
 a restore
Message-ID: <20131119182917.GA4842@kroah.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
 <1384867428-8395-2-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384867428-8395-2-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"trigs"?  Come on, we don't have a lack of characters here...

On Tue, Nov 19, 2013 at 09:23:40PM +0800, Peng Tao wrote:
> From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
> 
> When a client accesses data in a released file,
> or truncate it, client must trig a restore request.
> During this restore, the client must not glimpse and
> must use size from MDT. To bring the "restore is running"
> information on the client we add a new t_state bit field
> to mdt_info which will be used to carry transient file state.
> To memorise this information in the inode we add a new flag
> LLIF_FILE_RESTORING.
> 
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3432
> Lustre-change: http://review.whamcloud.com/6537
> Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
> Tested-by: Oleg Drokin <oleg.drokin@intel.com>
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> ---
>  drivers/staging/lustre/lustre/include/cl_object.h  |    6 ++-
>  .../lustre/lustre/include/lustre/lustre_idl.h      |   14 +++--
>  drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    6 +++
>  drivers/staging/lustre/lustre/llite/file.c         |   39 +++++++++++++-
>  .../staging/lustre/lustre/llite/llite_internal.h   |    3 ++
>  drivers/staging/lustre/lustre/llite/llite_lib.c    |   36 +++++++++++++
>  drivers/staging/lustre/lustre/llite/vvp_io.c       |   54 ++++++++++++++++++--
>  drivers/staging/lustre/lustre/lov/lov_io.c         |   15 ++++--
>  .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    2 +-
>  drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   17 +++---
>  10 files changed, 168 insertions(+), 24 deletions(-)

This patch has checkpatch errors, sorry, please fix them before sending
them again.

greg k-h
