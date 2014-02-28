Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaB1DoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:44:06 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:51863 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaB1DoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:44:04 -0500
MIME-Version: 1.0
In-Reply-To: <52E42B86.1020701@web.de>
References: <52E42B86.1020701@web.de>
Date: Thu, 27 Feb 2014 22:44:03 -0500
X-Google-Sender-Auth: fgUyLAowHD8-lBkcIL2z6fkP-34
Message-ID: <CAJvTdK=4+fDpPCzy16gch+21JH_t-icixehEkdz_wJBSvrZFXw@mail.gmail.com>
Subject: Re: [PATCH] intel_idle: Add CPU model 54 (Atom N2000 series)
From: Len Brown <lenb@kernel.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

Note that the difference that will be noticed most will be that ACPI
on this kind of box typically offers the deepest C-state only when
on DC, and disables it on DC.  intel_idle offers it no matter
if the box is on AC or DC.

thanks,
-Len Brown, Intel Open Source Technology Center


On Sat, Jan 25, 2014 at 4:24 PM, Jan Kiszka <jan.kiszka@web.de> wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
>
> Add CPU ID for Atom N2600/N2800 processors. Datasheets indicate support
> for this, detailed information about potential quirks or limitations are
> missing, though. So we just reuse the definition for the previous ATOM
> series. Tests on N2800 systems showed that this addition is fine an can
> reduce power consumption by about 0.25 W (personally confirmed on Intel
> DN2800MT).
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  drivers/idle/intel_idle.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 797ed29..6467fc9 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -503,6 +503,7 @@ static const struct x86_cpu_id intel_idle_ids[] = {
>         ICPU(0x2f, idle_cpu_nehalem),
>         ICPU(0x2a, idle_cpu_snb),
>         ICPU(0x2d, idle_cpu_snb),
> +       ICPU(0x36, idle_cpu_atom),
>         ICPU(0x3a, idle_cpu_ivb),
>         ICPU(0x3e, idle_cpu_ivb),
>         ICPU(0x3c, idle_cpu_hsw),
>
>



-- 
Len Brown, Intel Open Source Technology Center
