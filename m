Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaFBAKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:10:42 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:62736 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaFBAKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:10:40 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1401577712-4447-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401577712-4447-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 1 Jun 2014 17:10:39 -0700
Message-ID: <CAOesGMi4SGRP6_WMgv3xz_QrGScktYGQEK-muCrE=ohFBfeBeQ@mail.gmail.com>
Subject: Re: [PATCH] atm: fore200e.c: Cleaning up uninitialized variables
From: Olof Johansson <olof@lixom.net>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-atm-general@lists.sourceforge.net,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 4:08 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/atm/fore200e.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
> index 204814e..d4725fc 100644
> --- a/drivers/atm/fore200e.c
> +++ b/drivers/atm/fore200e.c
> @@ -2780,7 +2780,7 @@ static struct pci_driver fore200e_pca_driver = {
>
>  static int __init fore200e_module_init(void)
>  {
> -       int err;
> +       int err = 0;
>
>         printk(FORE200E "FORE Systems 200E-series ATM driver - version " FORE200E_VERSION "\n");


I can see how a tool that doesn't know about Kconfig dependencies
might think so, but if you look at Kconfig you'll see that for this
driver to be enabled for building either CONFIG_SBUS or CONFIG_PCI
must be set, and if either of them is then this variable will not be
used without first being set.


-Olof
