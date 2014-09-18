Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaIRUmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:42:13 -0400
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:39520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756203AbaIRUmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:42:11 -0400
Date: Thu, 18 Sep 2014 15:22:33 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Alexander Graf <agraf@suse.de>
CC: German Rivera <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<scottwood@freescale.com>" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140918152233.41647ee517393816bb35b72a@freescale.com>
In-Reply-To: <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(35774003)(24454002)(52314003)(377454003)(479174003)(51704005)(189002)(15975445006)(85306004)(90102001)(88136002)(93886004)(106466001)(105606002)(102836001)(95666004)(104016003)(79102003)(46406003)(68736004)(62966002)(84676001)(85852003)(81342003)(83072002)(89996001)(26826002)(74502003)(74662003)(80022003)(97736003)(44976005)(19580405001)(100306002)(6806004)(19580395003)(50466002)(83322001)(107046002)(47776003)(23726002)(20776003)(50986999)(76482002)(77982003)(92566001)(81542003)(33646002)(76176999)(46102003)(77156001)(99396002)(86362001)(21056001)(92726001)(64706001)(93916002)(104166001)(36756003)(31966008)(4396001)(50226001)(87936001)(87286001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0747;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 15:14:03 +0200
Alexander Graf <agraf@suse.de> wrote:

> > Am 18.09.2014 um 06:17 schrieb German Rivera <German.Rivera@freescale.com>:
> > 
> >> On 09/15/2014 06:44 PM, Kim Phillips wrote:
> >> On Thu, 11 Sep 2014 12:34:21 -0500
> >> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> >> 
> >>> From: "J. German Rivera" <German.Rivera@freescale.com>
> >>> 
> >>> APIs to access the Management Complex (MC) hardware
> >>> module of Freescale LS2 SoCs. This patch includes
> >>> APIs to check the MC firmware version and to manipulate
> >>> DPRC objects in the MC.
> >>> 
> >>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> >>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> >>> ---
> >>>  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
> >>>  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
> >>>  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
> >>>  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
> >>>  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
> >>>  include/linux/fsl_dpmng.h          |  120 ++++++
> >>>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
> >>>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
> >>>  include/linux/fsl_mc_sys.h         |   81 ++++
> >>>  9 files changed, 2635 insertions(+)
> >>>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
> >>>  create mode 100644 drivers/bus/fsl-mc/dprc.c
> >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
> >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
> >>>  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
> >>>  create mode 100644 include/linux/fsl_dpmng.h
> >>>  create mode 100644 include/linux/fsl_dprc.h
> >>>  create mode 100644 include/linux/fsl_mc_cmd.h
> >>>  create mode 100644 include/linux/fsl_mc_sys.h
> >> 
> >> the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
> >> its directory name fsl-mc/.  Note that I find dashes ('-') in
> >> filenames make them easier to type: is there a reason we're using
> >> underscores here?
> > This is a convention that we decided early on '-' for directory names
> > and '_' for file names.

based on what?

> > unnecessarily complicated error path, plus a simpler
> >> implementation can be made if fn can return the mapped address, like
> >> so:
> >> 
> >> static void __iomem *map_mc_portal(phys_addr_t mc_portal_phys_addr,
> >>                                    uint32_t mc_portal_size)
> >> {
> >>         struct resource *res;
> >>         void __iomem *mapped_addr;
> >> 
> >>         res = request_mem_region(mc_portal_phys_addr, mc_portal_size,
> >>                                  "mc_portal");
> >>         if (!res)
> >>                 return NULL;
> >> 
> >>         mapped_addr = ioremap_nocache(mc_portal_phys_addr,
> >>                                       mc_portal_size);
> >>         if (!mapped_addr)
> >>                 release_mem_region(mc_portal_phys_addr, mc_portal_size);
> >> 
> >>         return mapped_addr;
> >> }
> >> 
> >> the callsite can return -ENOMEM to its caller if returned NULL.  This
> >> can be improved even further if devm_ functions are used:  this is
> >> just an example of how to simplify the code using early returns
> >> instead of goto error.
> > 
> > I disagree. Having a common error return point is more maintainable than having multiple returns as having the clean-up logic in one place is more maintainable and makes the min path (non-error) more readable.

my comment is not that much different from Joe's here:

https://lkml.org/lkml/2014/9/17/381

but hopefully all this will change with a devm_ based implementation.

> >>> +int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
> >>> +                  uint32_t mc_portal_size,
> >>> +                  uint32_t flags, struct fsl_mc_io **new_mc_io)
> >>> +{
> >>> +    int error = -EINVAL;
> >>> +    struct fsl_mc_io *mc_io = NULL;
> >>> +
> >>> +    mc_io = kzalloc(sizeof(*mc_io), GFP_KERNEL);
> >>> +    if (mc_io == NULL) {
> >>> +        error = -ENOMEM;
> >>> +        pr_err("No memory to allocate mc_io\n");
> >>> +        goto error;
> >>> +    }
> >>> +
> >>> +    mc_io->magic = FSL_MC_IO_MAGIC;
> >>> +    mc_io->flags = flags;
> >>> +    mc_io->portal_phys_addr = mc_portal_phys_addr;
> >>> +    mc_io->portal_size = mc_portal_size;
> >>> +    spin_lock_init(&mc_io->spinlock);
> >>> +    error = map_mc_portal(mc_portal_phys_addr,
> >>> +                  mc_portal_size, &mc_io->portal_virt_addr);
> >>> +    if (error < 0)
> >>> +        goto error;
> >>> +
> >>> +    *new_mc_io = mc_io;
> >>> +    return 0;
> >> 
> >> if a fn only returns an address or error, it can return ERR_PTR
> >> (e.g., -ENOMEM), and the callsite use IS_ERR() to determine whether
> >> there was an error or address returned.  This makes code much
> >> simpler instead of passing address values back by reference.
> > I disagree. I don't see why the alternative you suggest makes the code "much simpler".

because it eliminates the need for the extra pass-by-reference
argument struct fsl_mc_io **new_mc_io.

> >>> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
> >>> +{
> >>> +    if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
> >>> +        return;
> >>> +
> >>> +    if (mc_io->portal_virt_addr != NULL) {
> >>> +        unmap_mc_portal(mc_io->portal_phys_addr,
> >>> +                mc_io->portal_size, mc_io->portal_virt_addr);
> >> 
> >> unmap_mc_portal already checks for virt_addr, this is another
> >> example where the code goes too far checking for NULL.
> > I disagree. Having the extra check is harmless and more importantly makes the intent explicit that we should only call unmap_mc_portal if we called map_mc_portal earlier.

the code is doing this:

        if (mc_io->portal_virt_addr != NULL) {
	        if (WARN_ON(mc_portal_virt_addr == NULL))
        	        return;

which is redundant and therefore makes it unnecessarily complicated,
after all, a stack trace will occur if mc_portal_virt_addr is
referenced anyway, making the WARN_ON clause redundant, too.

> >>> +        mc_io->portal_virt_addr = NULL;
> >>> +    }
> >>> +
> >>> +    mc_io->magic = 0x0;
> >>> +    kfree(mc_io);
> >>> +}

btw, what's the point of zeroing out things that are being freed?

> >>> +/**
> >>> + * @brief    Management Complex firmware version information
> >>> + */
> >>> +#define MC_VER_MAJOR 2
> >>> +#define MC_VER_MINOR 0
> >> 
> >> code should be adjusted to run on all *compatible* versions of h/w,
> >> not strictly the one set in these defines.
> > This comment is not precise enough be actionable.
> > What exactly you want to be changed  here?
> 
> I think the easy thing to do is to convert the exact version check into a ranged version check: have minimum and maximum versions you support. Or a list of exact versions you support. Or not check for the version at all - or only for the major version and guarantee that the major version indicates backwards compatibility.

yes, this was my point: elsewhere I noticed the code denies to run
iff those defines are not matched exactly: that code should change
to run as Alex describes.

> >>> +/**
> >>> + * @brief    Disconnects one endpoint to remove its network link
> >>> + *
> >>> + * @param[in]   mc_io        Pointer to opaque I/O object
> >>> + * @param[in]    dprc_handle    Handle to the DPRC object
> >>> + * @param[in]   endpoint    Endpoint configuration parameters.
> >>> + *
> >>> + * @returns    '0' on Success; Error code otherwise.
> >>> + * */
> >>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
> >>> +            struct dprc_endpoint *endpoint);
> >>> +
> >>> +/*! @} */
> >> 
> >> this entire file is riddled with non-kernel-doc comment markers:  see
> >> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
> >> other types of comments in a kernel-doc compliant format.
> > This is because this file is using doxygen comments, as it was developed
> > by another team. Unless someone else has an objection, I will leave the doxygen comments alone and not make any change here.
> 
> Do you see any other source files in Linux using doxygen comments? Mixing different documentation styles can easily become a big mess, because you can't generate external documentation consistently for the whole tree.

Thanks Alex,

Kim
