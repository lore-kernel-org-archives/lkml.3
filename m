Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbbAOWY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:24:28 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33277 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbbAOWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:24:25 -0500
Date: Thu, 15 Jan 2015 16:24:22 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] PCI: clip firmware assigned resources
Message-ID: <20150115222422.GB29776@google.com>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 08:31:27PM -0800, Yinghai Lu wrote:
> During the fix https://bugzilla.kernel.org/show_bug.cgi?id=85491,
> Bjorn suggest that we should clip the resources instead of just
> reject them.
> 
> We should only need first two for x86. others for related arches
> to keep them consistent.
> 
> -v2: only handle bridge resource, and add pci_claim_bridge_resource
> 	in pci core code.
> 
> Thanks
> 
> Yinghai
> 
> Yinghai Lu (10):
>   PCI: clip firmware assigned resource under parent bridge's
>   PCI, x86: clip firmware assigned resource under parent bridge's
>   PCI, alpha: clip firmware assigned resource under parent bridge's
>   PCI, frv: clip firmware assigned resource under parent bridge's
>   PCI, ia64: clip firmware assigned resource under parent bridge's
>   PCI, microblaze: clip firmware assigned resource under parent bridge's
>   PCI, mn10300: clip firmware assigned resource under parent bridge's
>   PCI, parisc: clip firmware assigned resource under parent bridge's
>   PCI, powerpc: clip firmware assigned resource under parent bridge's
>   PCI, sparc: clip firmware assigned resource under parent bridge's
> 
>  arch/alpha/kernel/pci.c                 |  8 +++--
>  arch/frv/mb93090-mb00/pci-frv.c         |  2 +-
>  arch/ia64/pci/pci.c                     | 48 +++++++++++++---------------
>  arch/microblaze/pci/pci-common.c        | 13 +++++++-
>  arch/mn10300/unit-asb2305/pci-asb2305.c |  2 +-
>  arch/mn10300/unit-asb2305/pci.c         | 47 +++++++++++++--------------
>  arch/powerpc/kernel/pci-common.c        | 12 ++++++-
>  arch/sparc/kernel/pci.c                 |  5 ++-
>  arch/x86/pci/i386.c                     |  2 +-
>  drivers/parisc/lba_pci.c                |  5 ++-
>  drivers/pci/bus.c                       | 39 +++++++++++++++++++++++
>  drivers/pci/pci.h                       |  1 +
>  drivers/pci/setup-bus.c                 | 56 ++++++++++++++++++++++++++-------
>  include/linux/pci.h                     |  1 +
>  14 files changed, 165 insertions(+), 76 deletions(-)

Applied to for-linus for v3.19, thanks.  This is significantly different
from v1, so I didn't add acks and testing info from Helge and Wei.

Bjorn
