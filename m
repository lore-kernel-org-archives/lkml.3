Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab3ANXd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:33:29 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34274 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611Ab3ANXdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:33:25 -0500
MIME-Version: 1.0
In-Reply-To: <1354025380-19092-1-git-send-email-colin.king@canonical.com>
References: <1354025380-19092-1-git-send-email-colin.king@canonical.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 14 Jan 2013 16:33:04 -0700
Message-ID: <CAErSpo46jV0C0QCC9_=Bg+B8214eGcDNFtg_udzBv2fqQDHhdg@mail.gmail.com>
Subject: Re: [PATCH RESEND] PCI: Allow pcie_aspm=force to work even when FADT
 indicates it is unsupported
To: Colin King <colin.king@canonical.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 7:09 AM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> BugLink: http://bugs.launchpad.net/bugs/962038
>
> Right now using pcie_aspm=force will not enable ASPM if the FADT indicates
> ASPM is unsupported.  However, the semantics of force should probably allow
> for this, especially as they did before the ASPM disable rework with commit
> 3c076351c4027a56d5005a39a0b518a4ba393ce2
>
> This patch just skips the clearing of any ASPM setup that the firmware has
> carried out on this bus if pcie_aspm=force is being used.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

I applied this to my for-linus branch, so it should appear in v3.8.
Thanks, and sorry for the delay in applying this.

Bjorn

> ---
>  drivers/pci/pcie/aspm.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
> index 213753b..449f257 100644
> --- a/drivers/pci/pcie/aspm.c
> +++ b/drivers/pci/pcie/aspm.c
> @@ -773,6 +773,9 @@ void pcie_clear_aspm(struct pci_bus *bus)
>  {
>         struct pci_dev *child;
>
> +       if (aspm_force)
> +               return;
> +
>         /*
>          * Clear any ASPM setup that the firmware has carried out on this bus
>          */
> --
> 1.8.0
>
