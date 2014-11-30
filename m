Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaK3Q65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:58:57 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61209 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaK3Q6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:58:55 -0500
Date: Sun, 30 Nov 2014 17:58:50 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: gregkh@linuxfoundation.org, paul.gortmaker@windriver.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:octeon:ethernet-rx.c: Added blank line
 after declarations
Message-ID: <20141130165850.GA5709@t400>
References: <1417364729-5279-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417364729-5279-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30, Anjana Sasindran wrote:
> This patch fixes the checkpatch.pl warnings:

Your subject line is somewhat broken as it does not really follow the
canonical patch format. You can read up on it here (section 15)
https://www.kernel.org/doc/Documentation/SubmittingPatches and this is
the short version:

	- it is not necessary to put the full path to the driver/file in
	  the subject line. The patches that apply to the staging start
	  with the 'staging' mark (so no need for the 'drivers')
	  followed by the driver name ('octeon' in this case).

	- the file name is not needed in the subject as this information
	  is in the diff anyway.

	- use the space after the colon ':' because otherwise it is hard
	  to read.

Hope this pays offs in the future.

Thanks,
Konrad
 
> WARNING: Missing blank line after declaration
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/octeon/ethernet-rx.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index 44e372f..61131ff 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -84,6 +84,7 @@ static int cvm_irq_cpu;
>  static void cvm_oct_enable_napi(void *_)
>  {
>  	int cpu = smp_processor_id();
> +
>  	napi_schedule(&cvm_oct_napi[cpu].napi);
>  }
>  
> @@ -169,6 +170,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
>  		int interface = cvmx_helper_get_interface_num(work->ipprt);
>  		int index = cvmx_helper_get_interface_index_num(work->ipprt);
>  		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
> +
>  		gmxx_rxx_frm_ctl.u64 =
>  		    cvmx_read_csr(CVMX_GMXX_RXX_FRM_CTL(index, interface));
>  		if (gmxx_rxx_frm_ctl.s.pre_chk == 0) {
> @@ -272,6 +274,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
>  		did_work_request = 0;
>  		if (work == NULL) {
>  			union cvmx_pow_wq_int wq_int;
> +
>  			wq_int.u64 = 0;
>  			wq_int.s.iq_dis = 1 << pow_receive_group;
>  			wq_int.s.wq_int = 1 << pow_receive_group;
> @@ -296,6 +299,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
>  			union cvmx_pow_wq_int_cntx counts;
>  			int backlog;
>  			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
> +
>  			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
>  			backlog = counts.s.iq_cnt + counts.s.ds_cnt;
>  			if (backlog > budget * cores_in_use && napi != NULL)
> -- 
> 1.9.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
