Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaFPOSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:18:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:4114 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbaFPOSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:18:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,486,1400050800"; 
   d="scan'208";a="558251860"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Anil Belur <askb23@gmail.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v4 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Topic: [PATCH v4 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Index: AQHPiVT2M/bNVwjDEEutdeN0Qo7sBZt0PjgA
Date: Mon, 16 Jun 2014 14:17:56 +0000
Message-ID: <33547832-F895-4D4E-AB26-A4D4B11681B7@intel.com>
References: <1402917203-12798-1-git-send-email-askb23@gmail.com>
 <1402917203-12798-8-git-send-email-askb23@gmail.com>
In-Reply-To: <1402917203-12798-8-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8DA0C04454E4D44B6FB67731A703A27@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16, 2014, at 7:13 AM, Anil Belur wrote:

> From: Anil Belur <askb23@gmail.com>
> 
> fixed: WARNING: line over 80 characters, used a new variable 'check' to
> store the offset. Replace "unsigned long" with  "u64" type fir
> 'cur_index'
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
> drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> index c180a20..440d7c2 100644
> --- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> +++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> @@ -864,10 +864,11 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
> 				 * linux-2.6.18-128.1.1 miss to do that.
> 				 * --bug 17336 */
> 				loff_t size = cl_isize_read(inode);
> -				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
> +				u64 cur_index = start >> PAGE_CACHE_SHIFT;

Well, size is of type loff_t, so I imagine it's most natural to make cur_index to be loff_t too,
just like what you do with the newly added check (not very great name, btw, size_index?) variable

Bye,
    Oleg