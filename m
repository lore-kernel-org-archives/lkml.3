Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaLIFaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 00:30:03 -0500
Received: from ozlabs.org ([103.22.144.67]:33494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaLIFaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 00:30:01 -0500
Message-ID: <1418102997.527.3.camel@concordia>
Subject: Re: [PATCH] arch: powerpc: kernel: vio.c:  Remove unused function
From: Michael Ellerman <mpe@ellerman.id.au>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alistair Popple <alistair@popple.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walter <dwalter@google.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Tue, 09 Dec 2014 16:29:57 +1100
In-Reply-To: <1417991502-20223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1417991502-20223-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-07 at 23:31 +0100, Rickard Strandqvist wrote:
> Remove the function cmo_high_show() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/powerpc/kernel/vio.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
> index 5bfdab9..11657d2 100644
> --- a/arch/powerpc/kernel/vio.c
> +++ b/arch/powerpc/kernel/vio.c
> @@ -1032,11 +1032,6 @@ viobus_cmo_pool_rd_attr(reserve, size);
>  viobus_cmo_pool_rd_attr(excess, size);
>  viobus_cmo_pool_rd_attr(excess, free);
>  
> -static ssize_t cmo_high_show(struct bus_type *bt, char *buf)
> -{
> -	return sprintf(buf, "%lu\n", vio_cmo.high);
> -}


from ../arch/powerpc/kernel/vio.c:17:
../arch/powerpc/kernel/vio.c:1046:20: error: 'cmo_high_show' undeclared here (not in a function)
static BUS_ATTR_RW(cmo_high);
^
../include/linux/sysfs.h:76:10: note: in definition of macro '__ATTR'
.show = _show,      \
^
../include/linux/device.h:53:42: note: in expansion of macro '__ATTR_RW'
struct bus_attribute bus_attr_##_name = __ATTR_RW(_name)
^
../arch/powerpc/kernel/vio.c:1046:8: note: in expansion of macro 'BUS_ATTR_RW'
static BUS_ATTR_RW(cmo_high);
^

cheers


