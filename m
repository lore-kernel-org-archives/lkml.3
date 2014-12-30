Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaL3VYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:24:53 -0500
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:59997 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaL3VYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:24:52 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 16:24:52 EST
X-MXL-Hash: 54a318240c1c54d3-18cbbfe4019e6ab6c069c17f52776ab766e8eccd
X-MXL-Hash: 54a315bd702118ff-3a89eaae5affc3b66edee3d1d4b35f02d91098ac
Message-ID: <54A315AD.7000402@stratus.com>
Date: Tue, 30 Dec 2014 16:14:21 -0500
From: Joe Lawrence <joe.lawrence@stratus.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
CC: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <MPT-FusionLinux.pdl@avagotech.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [SCIS] mpt3sas: wait_for_completion_timeout timeout not reported
References: <1419956387-28252-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419956387-28252-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [134.111.23.94]
X-AnalysisOut: [v=2.1 cv=UrR3NoAB c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=rkJuIV0pGx0A:10 a=2Om]
X-AnalysisOut: [6y6CD4YAA:10 a=BLceEmwcHowA:10 a=N659UExz7-8A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=A92cGCtB03wA:10 a=wtyMjYgElqegx]
X-AnalysisOut: [TeINJoA:9 a=pILNOxqGKmIA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014123010); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 11:19 AM, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> this also should fail if timeout condition occurs. 
> 
> Thanks to Joe Lawrence <joe.lawrence@stratus.com> for confirmation.

How about this instead:

Acked-by: Joe Lawrence <joe.lawrence@stratus.com>

You still probably want a review from the Avago folks though.

BTW, don't worry about the "[SCSI]" subject prefix to the commit,
"[PATCH]" is fine.  I believe the former is a convention that the
maintainer applies to patches as he collects them to indicate that they
originated via the SCSI tree.

Thanks,

-- Joe

> this was only compile tested with
> x86_64_defconfig + CONFIG_SCSI_LOWLEVEL=y + CONFIG_SCSI_MPT3SAS=m
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_config.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
> index 4472c2a..04ff21b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -393,7 +393,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
>  	mpt3sas_base_put_smid_default(ioc, smid);
>  	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
>  	    timeout*HZ);
> -	if (!(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
> +	if (timeleft == 0 || !(ioc->config_cmds.status & MPT3_CMD_COMPLETE)) {
>  		pr_err(MPT3SAS_FMT "%s: timeout\n",
>  		    ioc->name, __func__);
>  		_debug_dump_mf(mpi_request,
> 
