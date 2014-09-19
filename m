Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaISAeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:34:24 -0400
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:47168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbaISAeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:34:23 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 20:34:23 EDT
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
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAC1K8A=
Date: Fri, 19 Sep 2014 00:18:44 +0000
Message-ID: <f803a62b35ad46ebbe56b06b27766dee@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
 <541A5CF1.8000409@freescale.com>
 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
In-Reply-To: <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(35774003)(189002)(199003)(164054003)(105586002)(20776003)(85306004)(50986999)(106116001)(76176999)(66066001)(106356001)(107046002)(86362001)(93886004)(101416001)(54356999)(64706001)(90102001)(74662003)(79102003)(80022003)(46102003)(77982003)(74502003)(81342003)(108616004)(81542003)(99396002)(76576001)(76482002)(33646002)(92566001)(77096002)(85852003)(83072002)(87936001)(95666004)(74316001)(99286002)(21056001)(83322001)(19580395003)(2656002)(4396001)(31966008)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0731;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+/**
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
> > by another team. Unless someone else has an objection, I will leave the doxygen comments alone and not make
> any change here.
> 
> Do you see any other source files in Linux using doxygen comments?

Yes.  Grep around a bit and you'll see examples of it.  I grep'ed for some
doxygen tags and found close to 200 source files with them.

> Mixing different documentation styles can
> easily become a big mess, because you can't generate external documentation consistently for the whole tree.

As German mentioned elsewhere, this file is an interface to a hardware block,
was written by another team targetting a wide variety of environments-- u-boot,
Linux, user space, other OSes etc.

We left the doxygen stuff there because while admitedly not used much, there
are other examples of it in the kernel and the documentation seems useful.
If it can't go into the kernel as is, we can just delete it.

If doxygen is not allowed, it would be nice to see checkpatch updated to complain.

Thanks,
Stuart
