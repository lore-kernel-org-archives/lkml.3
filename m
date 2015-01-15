Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbbAOQTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:19:37 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:45723 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbbAOQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:19:34 -0500
Date: Thu, 15 Jan 2015 10:19:31 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v2 04/10] PCI, frv: clip firmware assigned resource under
 parent bridge's
Message-ID: <20150115161931.GA7105@google.com>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
 <1421296297-6371-5-git-send-email-yinghai@kernel.org>
 <CAE9FiQXi05_uH-fmPVPJNdm93DHbb26h6vDvsNuQb-KGAT7ung@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXi05_uH-fmPVPJNdm93DHbb26h6vDvsNuQb-KGAT7ung@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 08:51:22PM -0800, Yinghai Lu wrote:
> On Wed, Jan 14, 2015 at 8:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > Some bios put range that is not fully coverred by root bus resources.
> > Try to clip them and update them in pci bridge bars.
> >
> > We'd like to fix other arches instead of just x86.
> >
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
> > Reported-by: Marek Kordik <kordikmarek@gmail.com>
> > Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> >  arch/frv/mb93090-mb00/pci-frv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
> > index 67b1d16..9e49c3e 100644
> > --- a/arch/frv/mb93090-mb00/pci-frv.c
> > +++ b/arch/frv/mb93090-mb00/pci-frv.c
> > @@ -94,7 +94,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
> >                                 r = &dev->resource[idx];
> >                                 if (!r->start)
> >                                         continue;
> > -                               pci_claim_resource(dev, idx);
> > +                               pci_claim_bridge_resource(dev, idx)
> 
> miss ; here.
> 
> Please let me know if you can fix it manually.

Fixed, thanks.
