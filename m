Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3KYXG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:06:57 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:43653 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3KYXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:06:55 -0500
MIME-Version: 1.0
In-Reply-To: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 25 Nov 2013 16:06:35 -0700
Message-ID: <CAErSpo6N+kkTQboe6Ai4-L1mE5QiFR5qe05r4gLsYacrzm-Npw@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: Do not use PCI ID macros in quirk names
To: Michal Marek <mmarek@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Joe Mario <jmario@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 6:40 AM, Michal Marek <mmarek@suse.cz> wrote:
> Pasting the verbatim PCI_(VENDOR|DEVICE)_* macros in the __pci_fixup_*
> symbol names results in insanely long names such as
>
> __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt
>
> When LTO adds its numeric suffix to such symbol, it overflows the
> namebuf[KSYM_NAME_LEN] array. Use the line number instead to create
> (nearly) unique symbol names.
>
> Reported-by: Joe Mario <jmario@redhat.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Joe Mario <jmario@redhat.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Applied to my for-linus branch for v3.13, thanks.

> ---
>  include/linux/pci.h | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index da172f9..1ff4dec 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1557,65 +1557,65 @@ enum pci_fixup_pass {
>  /* Anonymous variables would be nice... */
>  #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,        \
>                                   class_shift, hook)                    \
> -       static const struct pci_fixup __pci_fixup_##name __used         \
> +       static const struct pci_fixup __PASTE(__pci_fixup_##name,__LINE__) __used       \
>         __attribute__((__section__(#section), aligned((sizeof(void *)))))    \
>                 = { vendor, device, class, class_shift, hook };
>
>  #define DECLARE_PCI_FIXUP_CLASS_EARLY(vendor, device, class,           \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,                     \
> -               vendor##device##hook, vendor, device, class, class_shift, hook)
> +               hook, vendor, device, class, class_shift, hook)
>  #define DECLARE_PCI_FIXUP_CLASS_HEADER(vendor, device, class,          \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_header,                    \
> -               vendor##device##hook, vendor, device, class, class_shift, hook)
> +               hook, vendor, device, class, class_shift, hook)
>  #define DECLARE_PCI_FIXUP_CLASS_FINAL(vendor, device, class,           \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_final,                     \
> -               vendor##device##hook, vendor, device, class, class_shift, hook)
> +               hook, vendor, device, class, class_shift, hook)
>  #define DECLARE_PCI_FIXUP_CLASS_ENABLE(vendor, device, class,          \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_enable,                    \
> -               vendor##device##hook, vendor, device, class, class_shift, hook)
> +               hook, vendor, device, class, class_shift, hook)
>  #define DECLARE_PCI_FIXUP_CLASS_RESUME(vendor, device, class,          \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume,                    \
> -               resume##vendor##device##hook, vendor, device, class,    \
> +               resume##hook, vendor, device, class,    \
>                 class_shift, hook)
>  #define DECLARE_PCI_FIXUP_CLASS_RESUME_EARLY(vendor, device, class,    \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume_early,              \
> -               resume_early##vendor##device##hook, vendor, device,     \
> +               resume_early##hook, vendor, device,     \
>                 class, class_shift, hook)
>  #define DECLARE_PCI_FIXUP_CLASS_SUSPEND(vendor, device, class,         \
>                                          class_shift, hook)             \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,                   \
> -               suspend##vendor##device##hook, vendor, device, class,   \
> +               suspend##hook, vendor, device, class,   \
>                 class_shift, hook)
>
>  #define DECLARE_PCI_FIXUP_EARLY(vendor, device, hook)                  \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_early,                     \
> -               vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
> +               hook, vendor, device, PCI_ANY_ID, 0, hook)
>  #define DECLARE_PCI_FIXUP_HEADER(vendor, device, hook)                 \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_header,                    \
> -               vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
> +               hook, vendor, device, PCI_ANY_ID, 0, hook)
>  #define DECLARE_PCI_FIXUP_FINAL(vendor, device, hook)                  \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_final,                     \
> -               vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
> +               hook, vendor, device, PCI_ANY_ID, 0, hook)
>  #define DECLARE_PCI_FIXUP_ENABLE(vendor, device, hook)                 \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_enable,                    \
> -               vendor##device##hook, vendor, device, PCI_ANY_ID, 0, hook)
> +               hook, vendor, device, PCI_ANY_ID, 0, hook)
>  #define DECLARE_PCI_FIXUP_RESUME(vendor, device, hook)                 \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume,                    \
> -               resume##vendor##device##hook, vendor, device,           \
> +               resume##hook, vendor, device,           \
>                 PCI_ANY_ID, 0, hook)
>  #define DECLARE_PCI_FIXUP_RESUME_EARLY(vendor, device, hook)           \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_resume_early,              \
> -               resume_early##vendor##device##hook, vendor, device,     \
> +               resume_early##hook, vendor, device,     \
>                 PCI_ANY_ID, 0, hook)
>  #define DECLARE_PCI_FIXUP_SUSPEND(vendor, device, hook)                        \
>         DECLARE_PCI_FIXUP_SECTION(.pci_fixup_suspend,                   \
> -               suspend##vendor##device##hook, vendor, device,          \
> +               suspend##hook, vendor, device,          \
>                 PCI_ANY_ID, 0, hook)
>
>  #ifdef CONFIG_PCI_QUIRKS
> --
> 1.8.1.4
>
