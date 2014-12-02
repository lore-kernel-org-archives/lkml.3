Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaLBRcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:32:39 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49118 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbaLBRcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:32:36 -0500
Date: Tue, 2 Dec 2014 18:32:28 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Tejun Heo <tj@kernel.org>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.18-fixes] s390: fix machine check regression
 caused by the conversion from __get_cpu_var() to this_cpu_ptr()
In-Reply-To: <20141202171911.GD10918@htj.dyndns.org>
Message-ID: <alpine.LFD.2.11.1412021829260.1611@denkbrett>
References: <alpine.LFD.2.11.1411281544190.1648@denkbrett> <20141202171911.GD10918@htj.dyndns.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120217-0017-0000-0000-0000020FAD00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014, Tejun Heo wrote:
> Sorry about the delay.  Was on vacation.
> 
> Patch applied to percpu/for-3.18-fixes w/ minor updates to the patch
> subject and description.  Will push out to Linus soon.
> 

I've seen that Martin took the patch and it's already in Linus' tree -
commit 2cb4a18262fd0108cb8abd875710c59d0aa66f1d

Regards,
Sebastian

> Thanks.
> 
>  arch/s390/kernel/nmi.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
> index dd1c24c..3f51cf4 100644
> --- a/arch/s390/kernel/nmi.c
> +++ b/arch/s390/kernel/nmi.c
> @@ -54,12 +54,8 @@ void s390_handle_mcck(void)
>  	 */
>  	local_irq_save(flags);
>  	local_mcck_disable();
> -	/*
> -	 * Ummm... Does this make sense at all? Copying the percpu struct
> -	 * and then zapping it one statement later?
> -	 */
> -	memcpy(&mcck, this_cpu_ptr(&cpu_mcck), sizeof(mcck));
> -	memset(&mcck, 0, sizeof(struct mcck_struct));
> +	mcck = *this_cpu_ptr(&cpu_mcck);
> +	memset(this_cpu_ptr(&cpu_mcck), 0, sizeof(mcck));
>  	clear_cpu_flag(CIF_MCCK_PENDING);
>  	local_mcck_enable();
>  	local_irq_restore(flags);
> -- 
> 2.1.0
> 
> 

