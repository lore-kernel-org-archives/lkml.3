Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaIVO6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:58:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaIVO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:58:23 -0400
Date: Mon, 22 Sep 2014 07:57:33 -0700
From: "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: Kim Phillips <Kim.Phillips@freescale.com>, Alexander Graf <agraf@suse.de>,
        Jose Rivera <German.Rivera@freescale.com>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Message-ID: <20140922145733.GA7153@kroah.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
 <541A5CF1.8000409@freescale.com>
 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
 <a7c8cfc9520d49749f10c78e05b09cd5@CY1PR0301MB0748.namprd03.prod.outlook.com>
 <20140919155802.d5d8e80c7aff3b2ae81c6b50@freescale.com>
 <de1164ab115042aa9a2a9cafcc01ef1d@CY1PR0301MB0748.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de1164ab115042aa9a2a9cafcc01ef1d@CY1PR0301MB0748.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 02:42:10PM +0000, Stuart Yoder wrote:
> 
> 
> > -----Original Message-----
> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Friday, September 19, 2014 3:58 PM
> > To: Yoder Stuart-B08248
> > Cc: Alexander Graf; Rivera Jose-B46482; Phillips Kim-R1AAHA; <gregkh@linuxfoundation.org>; <arnd@arndb.de>;
> > <linux-kernel@vger.kernel.org>; Wood Scott-B07421; <linuxppc-release@linux.freescale.net>
> > Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> > 
> > On Fri, 19 Sep 2014 13:25:06 -0500
> > Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:
> > 
> > > > From: Yoder Stuart-B08248
> > > > Sent: Thursday, September 18, 2014 7:19 PM
> > > >
> > > > +/**
> > > > > >>> + * @brief    Disconnects one endpoint to remove its network link
> > > > > >>> + *
> > > > > >>> + * @param[in]   mc_io        Pointer to opaque I/O object
> > > > > >>> + * @param[in]    dprc_handle    Handle to the DPRC object
> > > > > >>> + * @param[in]   endpoint    Endpoint configuration parameters.
> > > > > >>> + *
> > > > > >>> + * @returns    '0' on Success; Error code otherwise.
> > > > > >>> + * */
> > > > > >>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
> > > > > >>> +            struct dprc_endpoint *endpoint);
> > > > > >>> +
> > > > > >>> +/*! @} */
> > > > > >>
> > > > > >> this entire file is riddled with non-kernel-doc comment markers:  see
> > > > > >> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
> > > > > >> other types of comments in a kernel-doc compliant format.
> > > > > > This is because this file is using doxygen comments, as it was developed
> > > > > > by another team. Unless someone else has an objection, I will leave the doxygen comments alone and
> > not
> > > > make
> > > > > any change here.
> > > > >
> > > > > Do you see any other source files in Linux using doxygen comments?
> > > >
> > > > Yes.  Grep around a bit and you'll see examples of it.  I grep'ed for some
> > > > doxygen tags and found close to 200 source files with them.
> > 
> > grepping for the one in this patch above - "! @}" - returns nothing.
> > 
> > > > > Mixing different documentation styles can
> > > > > easily become a big mess, because you can't generate external documentation consistently for the whole
> > > > tree.
> > > >
> > > > As German mentioned elsewhere, this file is an interface to a hardware block,
> > > > was written by another team targetting a wide variety of environments-- u-boot,
> > > > Linux, user space, other OSes etc.
> > > >
> > > > We left the doxygen stuff there because while admitedly not used much, there
> > > > are other examples of it in the kernel and the documentation seems useful.
> > > > If it can't go into the kernel as is, we can just delete it.
> > >
> > > ...to be clear, we could just delete the doyxen tags.  There is no scenario
> > > where I would envision anyone generating documentation from these files in
> > > the kernel.  The tags are there because of where we grabbed the source from.
> > > It certainly would benefit no one by conversion to kerneldoc.
> > 
> > except kerneldoc users :)
> > 
> > > However, just leaving the comments and doxygen tags alone as is would be nice.
> > 
> > they are incompatible with kerneldoc.
> 
> Seriously, no one is going to ever generate docs from this obscure bit of code
> documenting an internal interface within this driver.  Makes no sense to convert
> the comments to kerneldoc.
> 
> I completely get what you are saying with respect to comments actually documenting
> kernel interfaces used by different kernel components or uapi interfaces.
> 
> The doxygen tags are there because this code originated in a different project. That
> code was intended to be Linux-style compliant and complies with checkpatch --strict.
> However, we can sanitize the code and remove the tags if they are causing grief.
> It's too bad though, because we'll have to fork this interface code from its origin.

You "forked" the code when you asked for it be merged into the kernel
tree.  You shouldn't ever have to rely on the "old" version again, so
please, remove the doxygen mess.

greg k-h
