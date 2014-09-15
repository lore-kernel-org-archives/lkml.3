Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaIPBWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:22:47 -0400
Received: from mail-bn1on0144.outbound.protection.outlook.com ([157.56.110.144]:61061
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754111AbaIPBWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:22:43 -0400
X-Greylist: delayed 5586 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 21:22:43 EDT
Date: Mon, 15 Sep 2014 18:44:51 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <Kim.Phillips@freescale.com>, <scottwood@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140915184451.962a3a19c4940792d182f10a@freescale.com>
In-Reply-To: <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(164054003)(24454002)(51704005)(189002)(83322001)(19580395003)(87936001)(19580405001)(68736004)(23726002)(44976005)(79102001)(26826002)(102836001)(92566001)(97736003)(81342001)(107046002)(62966002)(99396002)(31966008)(50466002)(104016003)(33646002)(74662001)(74502001)(6806004)(95666004)(100306002)(81542001)(4396001)(77156001)(50226001)(90102001)(21056001)(77982001)(89996001)(36756003)(76176999)(50986999)(104166001)(106466001)(46102001)(105606002)(93916002)(88136002)(86362001)(64706001)(87286001)(47776003)(84676001)(92726001)(80022001)(20776003)(76482001)(85852003)(83072002)(46406003)(110136001)(85306004)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0725;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 12:34:21 -0500
"J. German Rivera" <German.Rivera@freescale.com> wrote:

> From: "J. German Rivera" <German.Rivera@freescale.com>
> 
> APIs to access the Management Complex (MC) hardware
> module of Freescale LS2 SoCs. This patch includes
> APIs to check the MC firmware version and to manipulate
> DPRC objects in the MC.
> 
> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> ---
>  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
>  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
>  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
>  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
>  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
>  include/linux/fsl_dpmng.h          |  120 ++++++
>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
>  include/linux/fsl_mc_sys.h         |   81 ++++
>  9 files changed, 2635 insertions(+)
>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
>  create mode 100644 drivers/bus/fsl-mc/dprc.c
>  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
>  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
>  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
>  create mode 100644 include/linux/fsl_dpmng.h
>  create mode 100644 include/linux/fsl_dprc.h
>  create mode 100644 include/linux/fsl_mc_cmd.h
>  create mode 100644 include/linux/fsl_mc_sys.h

the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
its directory name fsl-mc/.  Note that I find dashes ('-') in
filenames make them easier to type: is there a reason we're using
underscores here?

Also, any reason why these and future include files aren't being put
in include/linux/fsl/, so as to not pollute the top level
include/linux/?  That way, we can also remove the fsl- prefix from
those filenames, too..

> diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
> new file mode 100644
> index 0000000..c6ed27c
> --- /dev/null
> +++ b/drivers/bus/fsl-mc/dpmng.c
> @@ -0,0 +1,93 @@
> +/* Copyright 2013-2014 Freescale Semiconductor Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.
> + *
> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY

interesting, normally this text reads:

"THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"

...does that mean we're excluding non-Freescale copyright holders
and contributors from this warranty statement?  That doesn't seem
appropriate for an upstream kernel submission.

> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */

This dual BSD-3-clause/GPL license doesn't match that of patch 2's
drivers/bus/fsl-mc/fsl_mc_bus.c, GPLv2:

+/*
+ * Freescale Management Complex (MC) bus driver
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */

any reason the licenses are different?

> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
> +{
> +	struct mc_command cmd = { 0 };

we can save some cycles if this initialization is not absolutely
necessary: is it?  i.e., does the h/w actually look at the params
section when doing a get_version?  not sure to what other commands
this comment would apply to...at least get_container_id, but maybe
more - all of them?

> diff --git a/drivers/bus/fsl-mc/fsl_mc_sys.c b/drivers/bus/fsl-mc/fsl_mc_sys.c

> +/**
> + * Map an MC portal in the kernel virtual address space
> + */
> +static int map_mc_portal(phys_addr_t mc_portal_phys_addr,
> +			 uint32_t mc_portal_size,
> +			 void __iomem **new_mc_portal_virt_addr)
> +{
> +	void __iomem *mc_portal_virt_addr = NULL;
> +	struct resource *res = NULL;
> +	int error = -EINVAL;
> +
> +	res =
> +	    request_mem_region(mc_portal_phys_addr, mc_portal_size,
> +			       "mc_portal");
> +	if (res == NULL) {
> +		pr_err("request_mem_region() failed for MC portal %#llx\n",
> +		       mc_portal_phys_addr);
> +		error = -EBUSY;
> +		goto error;
> +	}
> +
> +	mc_portal_virt_addr = ioremap_nocache(mc_portal_phys_addr,
> +					      mc_portal_size);
> +	if (mc_portal_virt_addr == NULL) {
> +		pr_err("ioremap_nocache() failed for MC portal %#llx\n",
> +		       mc_portal_phys_addr);
> +		error = -EFAULT;
> +		goto error;
> +	}
> +
> +	*new_mc_portal_virt_addr = mc_portal_virt_addr;
> +	return 0;
> +error:
> +	if (mc_portal_virt_addr != NULL)
> +		iounmap(mc_portal_virt_addr);
> +
> +	if (res != NULL)
> +		release_mem_region(mc_portal_phys_addr, mc_portal_size);
> +
> +	return error;
> +}

unnecessary initializations, bad error codes (both should be
-ENOMEM), unnecessarily complicated error path, plus a simpler
implementation can be made if fn can return the mapped address, like
so:

static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
                                   uint32_t mc_portal_size)
{ 
        struct resource *res;
        void __iomem *mapped_addr;

        res = request_mem_region(mc_portal_phys_addr, mc_portal_size, 
                                 "mc_portal");
        if (!res) 
                return NULL;

        mapped_addr = ioremap_nocache(mc_portal_phys_addr,
                                      mc_portal_size);
        if (!mapped_addr)
                release_mem_region(mc_portal_phys_addr, mc_portal_size);

        return mapped_addr;
}

the callsite can return -ENOMEM to its caller if returned NULL.  This
can be improved even further if devm_ functions are used:  this is
just an example of how to simplify the code using early returns
instead of goto error.

> +int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
> +				  uint32_t mc_portal_size,
> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
> +{
> +	int error = -EINVAL;
> +	struct fsl_mc_io *mc_io = NULL;
> +
> +	mc_io = kzalloc(sizeof(*mc_io), GFP_KERNEL);
> +	if (mc_io == NULL) {
> +		error = -ENOMEM;
> +		pr_err("No memory to allocate mc_io\n");
> +		goto error;
> +	}
> +
> +	mc_io->magic = FSL_MC_IO_MAGIC;
> +	mc_io->flags = flags;
> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
> +	mc_io->portal_size = mc_portal_size;
> +	spin_lock_init(&mc_io->spinlock);
> +	error = map_mc_portal(mc_portal_phys_addr,
> +			      mc_portal_size, &mc_io->portal_virt_addr);
> +	if (error < 0)
> +		goto error;
> +
> +	*new_mc_io = mc_io;
> +	return 0;

if a fn only returns an address or error, it can return ERR_PTR
(e.g., -ENOMEM), and the callsite use IS_ERR() to determine whether
there was an error or address returned.  This makes code much
simpler instead of passing address values back by reference.

> +error:
> +	if (mc_io != NULL) {
> +		if (mc_io->portal_virt_addr != NULL) {
> +			unmap_mc_portal(mc_portal_phys_addr,
> +					mc_portal_size,
> +					mc_io->portal_virt_addr);
> +		}
> +
> +		kfree(mc_io);

kfree can handle being passed NULL, but again, might want to
consider using devm_ functions instead.

> +	}
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(fsl_create_mc_io);
> +
> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
> +{
> +	if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
> +		return;
> +
> +	if (mc_io->portal_virt_addr != NULL) {
> +		unmap_mc_portal(mc_io->portal_phys_addr,
> +				mc_io->portal_size, mc_io->portal_virt_addr);

unmap_mc_portal already checks for virt_addr, this is another
example where the code goes too far checking for NULL.

> +		mc_io->portal_virt_addr = NULL;
> +	}
> +
> +	mc_io->magic = 0x0;
> +	kfree(mc_io);
> +}
> +EXPORT_SYMBOL_GPL(fsl_destroy_mc_io);
> +
> +static int mc_status_to_error(enum mc_cmd_status status)
> +{
> +	switch (status) {
> +	case MC_CMD_STATUS_OK:
> +		return 0;
> +	case MC_CMD_STATUS_AUTH_ERR:
> +		return -EACCES;
> +	case MC_CMD_STATUS_NO_PRIVILEGE:
> +		return -EPERM;
> +	case MC_CMD_STATUS_DMA_ERR:
> +		return -EIO;
> +	case MC_CMD_STATUS_CONFIG_ERR:
> +		return -EINVAL;
> +	case MC_CMD_STATUS_TIMEOUT:
> +		return -ETIMEDOUT;
> +	case MC_CMD_STATUS_NO_RESOURCE:
> +		return -ENAVAIL;
> +	case MC_CMD_STATUS_NO_MEMORY:
> +		return -ENOMEM;
> +	case MC_CMD_STATUS_BUSY:
> +		return -EBUSY;
> +	case MC_CMD_STATUS_UNSUPPORTED_OP:
> +		return -ENOTSUP;
> +	case MC_CMD_STATUS_INVALID_STATE:
> +		return -ENODEV;
> +	default:
> +		break;
> +	}
> +
> +	/* Not expected to reach here */
> +	return -EINVAL;

but if it does, callsite can't disambiguate between that and e.g.,
MC_CMD_STATUS_CONFIG_ERR.  Also, this would be more readable as a
static const lookup table.

> +}
> +
> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
> +{
> +	enum mc_cmd_status status;
> +	unsigned long irqsave_flags = 0;
> +	int error = -EINVAL;
> +	bool lock_acquired = false;
> +	unsigned long jiffies_until_timeout =
> +	    jiffies + MC_CMD_COMPLETION_TIMEOUT;
> +
> +	if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
> +		goto out;

if the h/w signals an error on the bad magic condition, s/w doesn't
need to check it in its fast path.

> +	if (mc_io->flags & FSL_MC_IO_PORTAL_SHARED) {
> +		spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
> +		lock_acquired = true;
> +	}
> +
> +	mc_write_command(mc_io->portal_virt_addr, cmd);
> +
> +	for (;;) {
> +		status = mc_read_response(mc_io->portal_virt_addr, cmd);
> +		if (status != MC_CMD_STATUS_READY)
> +			break;
> +
> +		/*
> +		 * TODO: When MC command completion interrupts are supported
> +		 * call wait function here instead of udelay()
> +		 */
> +		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL);
> +		if (time_after_eq(jiffies, jiffies_until_timeout)) {
> +			error = -ETIMEDOUT;
> +			goto out;
> +		}
> +	}
> +
> +	error = mc_status_to_error(status);
> +out:
> +	if (lock_acquired)
> +		spin_unlock_irqrestore(&mc_io->spinlock, irqsave_flags);

so if the portal is shared, we take a lock, disable interrupts, and
then potentially udelay for a whopping 500usec, then check to see if
_100_usec have passed, and thus _always_ issue a timeout error, even
if the device took < 100usec to consume the command???

Not to mention this code will spin perpetually with IRQs disabled if
the read_response never returns ready.  I also don't see a reason
why IRQs are being disabled in the first place - it's not being used
in an IRQ handler...perhaps we need to wait until command completion
IRQs are supported :)

> +/**
> + * @brief	Management Complex firmware version information
> + */
> +#define MC_VER_MAJOR 2
> +#define MC_VER_MINOR 0

code should be adjusted to run on all *compatible* versions of h/w,
not strictly the one set in these defines.

> +/**
> + * @brief	Disconnects one endpoint to remove its network link
> + *
> + * @param[in]   mc_io		Pointer to opaque I/O object
> + * @param[in]	dprc_handle	Handle to the DPRC object
> + * @param[in]   endpoint	Endpoint configuration parameters.
> + *
> + * @returns	'0' on Success; Error code otherwise.
> + * */
> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
> +		    struct dprc_endpoint *endpoint);
> +
> +/*! @} */

this entire file is riddled with non-kernel-doc comment markers:  see
Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
other types of comments in a kernel-doc compliant format.

> +#ifdef FSL_MC_FIRMWARE
> +/*
> + * MC firmware decodes MC command parameters and encodes MC response parameters
> + */
> +
> +#define MC_CMD_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
> +	((_arg) = (_type)u64_dec((_cmd).params[_param], (_offset), (_width)))
> +
> +#define MC_RSP_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
> +	((_cmd).params[_param] |= u64_enc((_offset), (_width), (_type)(_arg)))
> +
> +#else
> +/*
> + * MC clients (GPP side) encode MC command parameters and decode MC response
> + * parameters
> + */
> +
> +#define MC_CMD_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
> +	((_cmd).params[_param] |= u64_enc((_offset), (_width), (_type)(_arg)))
> +
> +#define MC_RSP_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
> +	((_arg) = (_type)u64_dec((_cmd).params[_param], (_offset), (_width)))
> +
> +#endif /* FSL_MC_FIRMWARE */

FSL_MC_FIRMWARE isn't being defined anywhere; remove.

> diff --git a/include/linux/fsl_mc_sys.h b/include/linux/fsl_mc_sys.h
...
> +#ifndef ENOTSUP
> +#define ENOTSUP		95
> +#endif

This is already being defined as EOPNOTSUPP: either use that,
ENOTSUPP, or, if you can justify it, patch a more generic errno.h
as a separate patch, earlier in the patchseries.

> +#define ioread64(_p)	    readq(_p)
> +#define iowrite64(_v, _p)   writeq(_v, _p)

these definitions have names that are too generic to belong in a FSL
h/w header: conflicts will be introduced once the existing
io{read,write}32 functions get promoted.  Either use readq/writeq
directly, or, if you can justify it, patch a more generic io.h.

Also, is there a reason the 'relaxed' versions of the i/o accessors
aren't being used?

I'm stopping my review here, since I expect numerous changes in the
subsequent patches as a result of changes to this one in the next
version of the series.

Thanks,

Kim
