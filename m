Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaBMO4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:56:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaBMO4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:56:45 -0500
Message-ID: <1392303375.2771.28.camel@deneb.redhat.com>
Subject: Re: [PATCH 03/22] efi: add helper function to get UEFI params from
 FDT
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        patches@linaro.org
Date: Thu, 13 Feb 2014 09:56:15 -0500
In-Reply-To: <20140213111637.GE20717@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
	 <1391619853-10601-4-git-send-email-leif.lindholm@linaro.org>
	 <20140213111637.GE20717@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 11:17 +0000, Matt Fleming wrote:
> On Wed, 05 Feb, at 05:03:54PM, Leif Lindholm wrote:
> > From: Mark Salter <msalter@redhat.com>
> > 
> > ARM and ARM64 architectures use the device tree to pass UEFI parameters
> > from stub to kernel. These parameters are things known to the stub but
> > not discoverable by the kernel after the stub calls ExitBootSerives().
> > There is a helper function in:
> > 
> >    drivers/firmware/efi/fdt.c
> > 
> > which the stub uses to add the UEFI parameters to the device tree.
> > This patch adds a complimentary helper function which UEFI runtime
> > support may use to retrieve the parameters from the device tree.
> > If an architecture wants to use this helper, it should select
> > CONFIG_UEFI_PARAMS_FROM_FDT.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > ---
> >  drivers/firmware/efi/Kconfig |    7 ++++
> >  drivers/firmware/efi/efi.c   |   79 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/efi.h          |    9 +++++
> >  3 files changed, 95 insertions(+)
> 
> Is there a particular reason this change is being added to
> drivers/firmware/efi/efi.c and not drivers/firmware/efi/fdt.c?
> 

drivers/firmware/efi/fdt.c is included by the stub which may or may not
be linked into kernel image. This helper is used by runtime services and
needs to be built into kernel.

--Mark


