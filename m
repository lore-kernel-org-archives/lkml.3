Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3ILTTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab3ILTTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:19:48 -0400
Message-ID: <1379013584.14495.4.camel@deneb.redhat.com>
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
From: Mark Salter <msalter@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 12 Sep 2013 15:19:44 -0400
In-Reply-To: <52321022.6060907@tilera.com>
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
	 <52321022.6060907@tilera.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 15:04 -0400, Chris Metcalf wrote:
> On 9/12/2013 2:53 PM, Mark Salter wrote:
> > Remove messy dependencies from PARPORT_PC by having it depend on one
> > Kconfig symbol (ARCH_MAY_HAVE_PC_PARPORT) and having architectures
> > which need it declare ARCH_MAY_HAVE_PC_PARPORT in arch/*/Kconfig.
> > New architectures are unlikely to need PARPORT_PC, so this avoids
> > having an ever growing list of architectures to exclude. Those
> > architectures which do declare ARCH_MAY_HAVE_PC_PARPORT in this
> > patch are the ones which have an asm/parport.h.
> >
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> 
> You can actually omit the arch/tile change, since as far as I know there's no way for tile to have PARPORT_PC.
> 

Yeah, I thought that the list of architectures in the patch would end up
being a superset of what was really needed. Especially for those which
used the generic parport.h. I can drop tile from this patch but you may
want to get rid of the parport.h from arch/tile/include/asm/Kbuild.


