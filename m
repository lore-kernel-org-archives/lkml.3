Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKYPtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:49:04 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35049 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaKYPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:49:01 -0500
MIME-Version: 1.0
In-Reply-To: <54707ADB.30807@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<54707ADB.30807@users.sourceforge.net>
Date: Tue, 25 Nov 2014 10:48:59 -0500
Message-ID: <CAPoiz9znciQsg5ZXZf7xsM-8dt5umRnTX7RkEEADANQ6jqGEYQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: PCI-Calgary: Deletion of an unnecessary check
 before the function call "free_tce_table"
From: Jon Mason <jdmason@kudzu.us>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Muli Ben-Yehuda <muli@il.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        discuss@x86-64.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 7:00 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 22 Nov 2014 12:55:28 +0100
>
> The free_tce_table() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Looks good to me

Acked-by: Jon Mason <jdmason@kudzu.us>


> ---
>  arch/x86/kernel/pci-calgary_64.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index 0497f71..d22a386 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -1476,8 +1476,7 @@ cleanup:
>         for (--bus; bus >= 0; --bus) {
>                 struct calgary_bus_info *info = &bus_info[bus];
>
> -               if (info->tce_space)
> -                       free_tce_table(info->tce_space);
> +               free_tce_table(info->tce_space);
>         }
>         return -ENOMEM;
>  }
> --
> 2.1.3
>
