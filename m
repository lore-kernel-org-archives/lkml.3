Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbaISVD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:03:27 -0400
Received: from mail-bl2on0144.outbound.protection.outlook.com ([65.55.169.144]:53664
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757949AbaISVDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:03:21 -0400
Date: Fri, 19 Sep 2014 15:58:02 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Yoder Stuart-B08248 <stuart.yoder@freescale.com>
CC: Alexander Graf <agraf@suse.de>,
        Rivera Jose-B46482 <German.Rivera@freescale.com>,
        Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "Wood Scott-B07421" <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140919155802.d5d8e80c7aff3b2ae81c6b50@freescale.com>
In-Reply-To: <a7c8cfc9520d49749f10c78e05b09cd5@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	<a7c8cfc9520d49749f10c78e05b09cd5@CY1PR0301MB0748.namprd03.prod.outlook.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(199003)(51704005)(35774003)(189002)(377454003)(81342003)(46406003)(102836001)(83072002)(62966002)(84676001)(92726001)(50226001)(69596002)(31966008)(46102003)(68736004)(86362001)(85306004)(105606002)(76176999)(44976005)(4396001)(106466001)(85852003)(33646002)(95666004)(89996001)(6806004)(81156004)(26826002)(87286001)(107046002)(36756003)(50986999)(23726002)(104016003)(64706001)(93886004)(19580395003)(19580405001)(90102001)(77156001)(104166001)(77982003)(81542003)(93916002)(92566001)(50466002)(74662003)(100306002)(21056001)(80022003)(47776003)(99396002)(76482002)(88136002)(20776003)(97736003)(83322001)(74502003)(79102003)(87936001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB332;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 13:25:06 -0500
Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:

> > From: Yoder Stuart-B08248
> > Sent: Thursday, September 18, 2014 7:19 PM
> > 
> > +/**
> > > >>> + * @brief    Disconnects one endpoint to remove its network link
> > > >>> + *
> > > >>> + * @param[in]   mc_io        Pointer to opaque I/O object
> > > >>> + * @param[in]    dprc_handle    Handle to the DPRC object
> > > >>> + * @param[in]   endpoint    Endpoint configuration parameters.
> > > >>> + *
> > > >>> + * @returns    '0' on Success; Error code otherwise.
> > > >>> + * */
> > > >>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
> > > >>> +            struct dprc_endpoint *endpoint);
> > > >>> +
> > > >>> +/*! @} */
> > > >>
> > > >> this entire file is riddled with non-kernel-doc comment markers:  see
> > > >> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
> > > >> other types of comments in a kernel-doc compliant format.
> > > > This is because this file is using doxygen comments, as it was developed
> > > > by another team. Unless someone else has an objection, I will leave the doxygen comments alone and not
> > make
> > > any change here.
> > >
> > > Do you see any other source files in Linux using doxygen comments?
> > 
> > Yes.  Grep around a bit and you'll see examples of it.  I grep'ed for some
> > doxygen tags and found close to 200 source files with them.

grepping for the one in this patch above - "! @}" - returns nothing.

> > > Mixing different documentation styles can
> > > easily become a big mess, because you can't generate external documentation consistently for the whole
> > tree.
> > 
> > As German mentioned elsewhere, this file is an interface to a hardware block,
> > was written by another team targetting a wide variety of environments-- u-boot,
> > Linux, user space, other OSes etc.
> > 
> > We left the doxygen stuff there because while admitedly not used much, there
> > are other examples of it in the kernel and the documentation seems useful.
> > If it can't go into the kernel as is, we can just delete it.
> 
> ...to be clear, we could just delete the doyxen tags.  There is no scenario
> where I would envision anyone generating documentation from these files in
> the kernel.  The tags are there because of where we grabbed the source from.
> It certainly would benefit no one by conversion to kerneldoc.

except kerneldoc users :)

> However, just leaving the comments and doxygen tags alone as is would be nice.

they are incompatible with kerneldoc.

Kim
