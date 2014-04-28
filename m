Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaD1JNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:13:34 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51437 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaD1JN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:13:29 -0400
Message-ID: <535E1BB4.2070904@redhat.com>
Date: Mon, 28 Apr 2014 11:13:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of pci_enable_msix()
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com> <5304B09D.7010900@redhat.com> <20140221170414.GM17353@dhcp-26-207.brq.redhat.com> <20140221170504.GN17353@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140221170504.GN17353@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2014 18:05, Alexander Gordeev ha scritto:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  virt/kvm/assigned-dev.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index 8db4370..bf06577 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -395,7 +395,8 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
>  	if (dev->entries_nr == 0)
>  		return r;
>
> -	r = pci_enable_msix(dev->dev, dev->host_msix_entries, dev->entries_nr);
> +	r = pci_enable_msix_exact(dev->dev,
> +				  dev->host_msix_entries, dev->entries_nr);
>  	if (r)
>  		return r;
>
>

Applying this to kvm/master (i.e. for 3.15), thanks.

Paolo
