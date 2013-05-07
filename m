Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3EGWxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 18:53:33 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:35883 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3EGWxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 18:53:32 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130507204643.3ACA416E@viggo.jf.intel.com>
References: <20130507204642.D010DDC1@viggo.jf.intel.com>
	<20130507204643.3ACA416E@viggo.jf.intel.com>
Date: Tue, 7 May 2013 23:53:30 +0100
X-Google-Sender-Auth: zqRhE--0wpDzySIY0WiInx31qVI
Message-ID: <CAAG0J9-TBpSJ4yU3kTq-0b3f_Y2-vFbPZBoW9try2CYyyTsJHg@mail.gmail.com>
Subject: Re: [PATCH 1/7] consolidate per-arch stack overflow debugging options
From: James Hogan <james.hogan@imgtec.com>
To: Dave Hansen <dave@sr71.net>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2013 21:46, Dave Hansen <dave@sr71.net> wrote:
>
> From: Dave Hansen <dave@linux.vnet.ibm.com>
>
> Several architectures have similar stack debugging config options.
> They all pretty much do the same thing, some with slightly
> differing help text.
>
> This patch changes the architectures to instead enable a Kconfig
> boolean, and then use that boolean in the generic Kconfig.debug
> to present the actual menu option.  This removes a bunch of
> duplication and adds consistency across arches.
>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Reviewed-by: H. Peter Anvin <hpa@zytor.com>
> Reviewed-by: James Hogan <james.hogan@imgtec.com>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com> [for tile]
> Signed-off-by: Dave Hansen <dave.hansen@intel.com>
> ---
>
>  linux.git-davehans/arch/blackfin/Kconfig       |    1 +
>  linux.git-davehans/arch/blackfin/Kconfig.debug |    7 -------
>  linux.git-davehans/arch/frv/Kconfig            |    1 +
>  linux.git-davehans/arch/frv/Kconfig.debug      |    4 ----
>  linux.git-davehans/arch/m32r/Kconfig           |    1 +
>  linux.git-davehans/arch/m32r/Kconfig.debug     |    7 -------
>  linux.git-davehans/arch/mips/Kconfig           |    1 +
>  linux.git-davehans/arch/mips/Kconfig.debug     |    9 ---------
>  linux.git-davehans/arch/mn10300/Kconfig        |    1 +
>  linux.git-davehans/arch/mn10300/Kconfig.debug  |    4 ----
>  linux.git-davehans/arch/powerpc/Kconfig        |    1 +
>  linux.git-davehans/arch/powerpc/Kconfig.debug  |    7 -------
>  linux.git-davehans/arch/tile/Kconfig           |    1 +
>  linux.git-davehans/arch/tile/Kconfig.debug     |    7 -------
>  linux.git-davehans/arch/x86/Kconfig            |    1 +
>  linux.git-davehans/arch/x86/Kconfig.debug      |   10 ----------
>  linux.git-davehans/lib/Kconfig.debug           |   21 +++++++++++++++++++++
>  17 files changed, 29 insertions(+), 55 deletions(-)

Now that metag, arc, and openrisc architectures are merged, maybe you
could convert them too?

Cheers
James
