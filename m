Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaFQCIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:08:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:41030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbaFQCIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,491,1400050800"; 
   d="scan'208";a="446302215"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Anil Belur <askb23@gmail.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<tao.peng@emc.com>" <tao.peng@emc.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v5 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Topic: [PATCH v5 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Index: AQHPiX9eRK92eGKxJ0a7ARPjTUHA85t1BIIA
Date: Tue, 17 Jun 2014 02:08:50 +0000
Message-ID: <6FD758BB-2803-41BC-BFBF-2A607A68EAFA@intel.com>
References: <1402935742-18788-1-git-send-email-askb23@gmail.com>
 <1402935742-18788-8-git-send-email-askb23@gmail.com>
In-Reply-To: <1402935742-18788-8-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE65ACC791A92B48B6970837D316BE30@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16, 2014, at 12:22 PM, Anil Belur wrote:

> From: Anil Belur <askb23@gmail.com>
> 
> fixed: WARNING: line over 80 characters, used a new variable 'size_index' to
> store the offset. Replace "unsigned long" with  "u64" type for

Apparently you forgot to update the comment.

> 'cur_index'
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
> drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> index c180a20..6c5b828 100644
> --- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> +++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> @@ -864,10 +864,11 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
> 				 * linux-2.6.18-128.1.1 miss to do that.
> 				 * --bug 17336 */
> 				loff_t size = cl_isize_read(inode);
> -				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
> +				loff_t cur_index = start >> PAGE_CACHE_SHIFT;
> +				loff_t size_index = ((size - 1) >> PAGE_CACHE_SHIFT);
> 
> 				if ((size == 0 && cur_index != 0) ||
> -				    (((size - 1) >> PAGE_CACHE_SHIFT) < cur_index))
> +				    (size_index < cur_index))
> 				*exceed = 1;
> 			}
> 			return result;
> -- 
> 1.9.0
> 

Bye,
    Oleg