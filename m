Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaBSNY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:24:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46914 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBSNY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:24:57 -0500
Message-ID: <5304B09D.7010900@redhat.com>
Date: Wed, 19 Feb 2014 14:24:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] kvm: Use pci_enable_msix_range() instead of pci_enable_msix()
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
In-Reply-To: <1392804931-30671-11-git-send-email-agordeev@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/02/2014 11:15, Alexander Gordeev ha scritto:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  virt/kvm/assigned-dev.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index 8db4370..92e25e9 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -395,8 +395,9 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
>  	if (dev->entries_nr == 0)
>  		return r;
>
> -	r = pci_enable_msix(dev->dev, dev->host_msix_entries, dev->entries_nr);
> -	if (r)
> +	r = pci_enable_msix_range(dev->dev, dev->host_msix_entries,
> +				  dev->entries_nr, dev->entries_nr);
> +	if (r < 0)
>  		return r;
>
>  	for (i = 0; i < dev->entries_nr; i++) {
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
