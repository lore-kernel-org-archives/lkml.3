Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaLXNyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:54:16 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47236 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLXNyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:54:15 -0500
Date: Wed, 24 Dec 2014 14:53:47 +0100
From: Tristan Lelong <tristan@lelong.xyz>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, askb23@gmail.com, john.hammond@intel.com,
        gdonald@gmail.com, anhlq2110@gmail.com, fabio.falzoi84@gmail.com,
        oort10@gmail.com, agimenez@sysvalve.es, rupran@einserver.de,
        surya.seetharaman9@gmail.com, Julia.Lawall@lip6.fr, joe@perches.com,
        a.terekhov@gmail.com, liang.zhen@intel.com, vthakkar1994@gmail.com,
        amk@cray.com, srikrishanmalik@gmail.com, rd@radekdostal.com,
        bergwolf@gmail.com, dan.carpenter@oracle.com,
        paul.gortmaker@windriver.com, tapaswenipathak@gmail.com,
        email@christophjaeger.info, uja.ornl@gmail.com, brilliantov@inbox.ru,
        dmitry.eremin@intel.com
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
Message-ID: <20141224135346.GA6304@lenderer>
References: <1417910602-20953-1-git-send-email-tristan@lelong.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417910602-20953-1-git-send-email-tristan@lelong.xyz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 04:03:22PM -0800, Tristan Lelong wrote:
> This patch fix a sparse warning in lustre sources
> 
> warning: incorrect type in argument 1 (different address spaces)
>     expected void [noderef] <asn:1>*to
>     got char *<noident>
> 
> This is done by adding the missing __user attribute on userland pointers inside the LPROC_SEQ_FOPS like macros:
> - LPROC_SEQ_FOPS
> - LPROC_SEQ_FOPS_RW_TYPE
> - LPROC_SEQ_FOPS_WR_ONLY
> - LDLM_POOL_PROC_WRITER
> 
> The patch also updates all the functions that are used by this macro:
> - lprocfs_wr_*
> - *_seq_write
> 
> as well as some helpers used by the previously modified functions (otherwise fixing the sparse warning add some new ones):
> - lprocfs_write_frac_helper
> - lprocfs_write_helper
> - lprocfs_write_u64_helper
> 
> The patch also fixes one __user pointer direct dereference by strncmp in function fld_proc_hash_seq_write.
> 
> Signed-off-by: Tristan Lelong <tristan@lelong.xyz>
> ---
> Changes in v2:
>         Use dynamic allocation for 'name' variable instead of having it on the stack, per Greg K-H suggestion.
> 
> Changes in v3:
> 	Rename added variable from 'name' to 'fh_name'.
> 	Revert to a stack declaration of 'fh_name' since it is not 80 bytes but only 8, per Andreas Dilger comment.

Hi,

I just wanted to follow up on that patch to see if anybody had any comment.

Thanks

Regards
