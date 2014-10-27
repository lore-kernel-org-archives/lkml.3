Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaJ0TQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:16:40 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64458 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaJ0TQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <1414433284-31719-15-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-15-git-send-email-a.motakis@virtualopensystems.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Oct 2014 13:16:15 -0600
Message-ID: <CAErSpo55o00=YwtWChFaxC1tEAwv_A5nB90mDU9J6kpb9Tqf_Q@mail.gmail.com>
Subject: Re: [PATCH v9 14/19] vfio: move eventfd support code for VFIO_PCI to
 a separate file
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>, tech@virtualopensystems.com,
        Christoffer Dall <christoffer.dall@linaro.org>, eric.auger@linaro.org,
        kim.phillips@freescale.com, Marc Zyngier <marc.zyngier@arm.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonios,

On Mon, Oct 27, 2014 at 12:07 PM, Antonios Motakis
<a.motakis@virtualopensystems.com> wrote:
> The virqfd functionality that is used by VFIO_PCI to implement interrupt
> masking and unmasking via an eventfd, is generic enough and can be reused
> by another driver. Move it to a separate file in order to allow the code
> to be shared.
>
> Also properly export virqfd_enable and virqfd_disable in the process.

Alex will handle this, not me, but my personal preference is to avoid
doing things "in the process" because the small changes get lost in
the big patch.

I'd rather see a strict move that changes no code at all (except
things like necessary Makefile changes), followed by a smaller patch
that does the additional stuff.

Does "properly export" mean that those functions were previously
*improperly* exported and the way they used to be exported caused a
problem?  Or does it just mean "export"?

Bjorn

> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/Makefile               |   4 +-
>  drivers/vfio/pci/vfio_pci_intrs.c   | 213 -----------------------------------
>  drivers/vfio/pci/vfio_pci_private.h |   3 -
>  drivers/vfio/virqfd.c               | 214 ++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h                |  28 +++++
>  5 files changed, 245 insertions(+), 217 deletions(-)
>  create mode 100644 drivers/vfio/virqfd.c
