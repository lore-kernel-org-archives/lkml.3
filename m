Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaISSZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:25:15 -0400
Received: from mail-bl2on0109.outbound.protection.outlook.com ([65.55.169.109]:55119
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932269AbaISSZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:25:10 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alexander Graf <agraf@suse.de>, Jose Rivera <German.Rivera@freescale.com>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAC1K8CAATKJoA==
Date: Fri, 19 Sep 2014 18:25:06 +0000
Message-ID: <a7c8cfc9520d49749f10c78e05b09cd5@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
 <541A5CF1.8000409@freescale.com>
 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(35774003)(13464003)(189002)(199003)(377454003)(50986999)(93886004)(101416001)(76176999)(66066001)(20776003)(85306004)(105586002)(86362001)(76576001)(107046002)(106356001)(90102001)(106116001)(54356999)(79102003)(80022003)(33646002)(81542003)(74662003)(46102003)(81342003)(77982003)(74502003)(99396002)(108616004)(92566001)(76482002)(85852003)(77096002)(95666004)(83072002)(87936001)(21056001)(99286002)(74316001)(64706001)(19580395003)(19580405001)(2656002)(4396001)(31966008)(83322001)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0731;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Yoder Stuart-B08248
> Sent: Thursday, September 18, 2014 7:19 PM
> To: 'Alexander Graf'; Rivera Jose-B46482
> Cc: Phillips Kim-R1AAHA; <gregkh@linuxfoundation.org>; <arnd@arndb.de>; <linux-kernel@vger.kernel.org>; Wood
> Scott-B07421; <linuxppc-release@linux.freescale.net>
> Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> +/**
> > >>> + * @brief    Disconnects one endpoint to remove its network link
> > >>> + *
> > >>> + * @param[in]   mc_io        Pointer to opaque I/O object
> > >>> + * @param[in]    dprc_handle    Handle to the DPRC object
> > >>> + * @param[in]   endpoint    Endpoint configuration parameters.
> > >>> + *
> > >>> + * @returns    '0' on Success; Error code otherwise.
> > >>> + * */
> > >>> +int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
> > >>> +            struct dprc_endpoint *endpoint);
> > >>> +
> > >>> +/*! @} */
> > >>
> > >> this entire file is riddled with non-kernel-doc comment markers:  see
> > >> Documentation/kernel-doc-nano-HOWTO.txt on how to write function and
> > >> other types of comments in a kernel-doc compliant format.
> > > This is because this file is using doxygen comments, as it was developed
> > > by another team. Unless someone else has an objection, I will leave the doxygen comments alone and not
> make
> > any change here.
> >
> > Do you see any other source files in Linux using doxygen comments?
> 
> Yes.  Grep around a bit and you'll see examples of it.  I grep'ed for some
> doxygen tags and found close to 200 source files with them.
> 
> > Mixing different documentation styles can
> > easily become a big mess, because you can't generate external documentation consistently for the whole
> tree.
> 
> As German mentioned elsewhere, this file is an interface to a hardware block,
> was written by another team targetting a wide variety of environments-- u-boot,
> Linux, user space, other OSes etc.
> 
> We left the doxygen stuff there because while admitedly not used much, there
> are other examples of it in the kernel and the documentation seems useful.
> If it can't go into the kernel as is, we can just delete it.

...to be clear, we could just delete the doyxen tags.  There is no scenario
where I would envision anyone generating documentation from these files in
the kernel.  The tags are there because of where we grabbed the source from.
It certainly would benefit no one by conversion to kerneldoc.

However, just leaving the comments and doxygen tags alone as is would be nice.

Stuart

