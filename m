Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaKXTG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:06:59 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:56021 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaKXTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:06:57 -0500
Date: Mon, 24 Nov 2014 20:06:49 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] s390/pci: Deletion of unnecessary checks before the
 function call "debug_unregister"
In-Reply-To: <54709827.4050408@users.sourceforge.net>
Message-ID: <alpine.LFD.2.11.1411242004590.1608@denkbrett>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <54709827.4050408@users.sourceforge.net>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112419-0009-0000-0000-0000021E2C50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2014, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 22 Nov 2014 15:00:55 +0100
> 
> The debug_unregister() function performs also input parameter validation.
> Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  arch/s390/pci/pci_debug.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/pci/pci_debug.c b/arch/s390/pci/pci_debug.c
> index eec598c..18403a7 100644
> --- a/arch/s390/pci/pci_debug.c
> +++ b/arch/s390/pci/pci_debug.c
> @@ -158,10 +158,8 @@ int __init zpci_debug_init(void)
> 
>  void zpci_debug_exit(void)
>  {
> -	if (pci_debug_msg_id)
> -		debug_unregister(pci_debug_msg_id);
> -	if (pci_debug_err_id)
> -		debug_unregister(pci_debug_err_id);
> +	debug_unregister(pci_debug_msg_id);
> +	debug_unregister(pci_debug_err_id);
> 
>  	debugfs_remove(debugfs_root);
>  }

Applied.

Thanks,
Sebastian

