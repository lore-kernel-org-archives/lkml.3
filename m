Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3J2Wr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:47:28 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51661 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3J2Wr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:47:26 -0400
MIME-Version: 1.0
In-Reply-To: <20131023032412.12410.9371.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131023032140.12410.43295.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131023032412.12410.9371.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 29 Oct 2013 16:47:05 -0600
Message-ID: <CAErSpo7anfHRWGJojzVC6ggmoVEN_PosQqP2s6=DuxmrxEXcZg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mn10300/PCI: Remove useless pcibios_last_bus
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-am33-list@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 9:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> pcibios_last_bus was apparently copied from x86.  On mn10300, it is
> statically initialized to -1 and may be set with the "pci=lastbus=<X>"
> boot option, but it is never tested.  This patch removes everything
> related to pcibios_last_bus.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Applied to my pci/misc branch for v3.13.  Let me know if anybody objects.

> ---
>  arch/mn10300/unit-asb2305/pci-asb2305.h |    1 -
>  arch/mn10300/unit-asb2305/pci.c         |    5 -----
>  2 files changed, 6 deletions(-)
>
> diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.h b/arch/mn10300/unit-asb2305/pci-asb2305.h
> index 7fa66a0..9e17aca 100644
> --- a/arch/mn10300/unit-asb2305/pci-asb2305.h
> +++ b/arch/mn10300/unit-asb2305/pci-asb2305.h
> @@ -35,7 +35,6 @@ extern void pcibios_resource_survey(void);
>
>  /* pci.c */
>
> -extern int pcibios_last_bus;
>  extern struct pci_ops *pci_root_ops;
>
>  extern struct irq_routing_table *pcibios_get_irq_routing_table(void);
> diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
> index e37fac0..6b4339f 100644
> --- a/arch/mn10300/unit-asb2305/pci.c
> +++ b/arch/mn10300/unit-asb2305/pci.c
> @@ -24,7 +24,6 @@
>
>  unsigned int pci_probe = 1;
>
> -int pcibios_last_bus = -1;
>  struct pci_ops *pci_root_ops;
>
>  /*
> @@ -392,10 +391,6 @@ char *__init pcibios_setup(char *str)
>         if (!strcmp(str, "off")) {
>                 pci_probe = 0;
>                 return NULL;
> -
> -       } else if (!strncmp(str, "lastbus=", 8)) {
> -               pcibios_last_bus = simple_strtol(str+8, NULL, 0);
> -               return NULL;
>         }
>
>         return str;
>
