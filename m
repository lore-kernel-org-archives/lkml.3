Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaJAC11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:27:27 -0400
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:20550
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbaJAC1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:27:25 -0400
Message-ID: <1412130432.13320.342.camel@snotra.buserror.net>
Subject: Re: [PATCH 3/3 v2] drivers/bus: Device driver for FSL-MC DPRC
 devices
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur@tabi.org>
CC: "J. German Rivera" <German.Rivera@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        <stuart.yoder@freescale.com>,
        Kim Phillips <Kim.Phillips@freescale.com>,
        Alexander Graf <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Date: Tue, 30 Sep 2014 21:27:12 -0500
In-Reply-To: <CAOZdJXWqpPypHg1iw7Tg-d=2g=+qnHh-=BK_9_yJKzpooe0+YQ@mail.gmail.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
	 <1411166981-3610-4-git-send-email-German.Rivera@freescale.com>
	 <CAOZdJXWqpPypHg1iw7Tg-d=2g=+qnHh-=BK_9_yJKzpooe0+YQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9182:1110:33a1:a006]
X-ClientProxiedBy: DM2PR11CA0035.namprd11.prod.outlook.com (25.160.91.45) To
 CY1PR0301MB0730.namprd03.prod.outlook.com (25.160.159.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0730;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(189002)(199003)(377454003)(24454002)(62966002)(77096002)(19580395003)(46102003)(93916002)(92726001)(105586002)(19580405001)(99396003)(64706001)(31966008)(88136002)(33646002)(92566001)(86362001)(106356001)(10300001)(80022003)(20776003)(95666004)(107046002)(50986999)(87286001)(23676002)(42186005)(120916001)(85852003)(102836001)(4396001)(50226001)(77156001)(76176999)(104166001)(76482002)(110136001)(50466002)(101416001)(89996001)(21056001)(47776003)(103116003)(87976001)(85306004)(97736003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0730;H:[IPv6:2601:2:5800:3f7:9182:1110:33a1:a006];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 21:19 -0500, Timur Tabi wrote:
> On Fri, Sep 19, 2014 at 5:49 PM, J. German Rivera
> <German.Rivera@freescale.com> wrote:
> > +/**
> > + * dprc_remove_devices - Removes devices for objects removed from a DPRC
> > + *
> > + * @mc_bus_dev: pointer to the fsl-mc device that represents a DPRC object
> > + * @obj_desc_array: array of object descriptors for child objects currently
> > + * present in the DPRC in the MC.
> > + * @num_child_objects_in_mc: number of entries in obj_desc_array
> > + *
> > + * Synchronizes the state of the Linux bus driver with the actual state of
> > + * the MC by removing devices that represent MC objects that have
> > + * been dynamically removed in the physical DPRC.
> > + */
> > +static void dprc_remove_devices(struct fsl_mc_device *mc_bus_dev,
> > +                               struct dprc_obj_desc *obj_desc_array,
> > +                               int num_child_objects_in_mc)
> > +{
> > +       if (num_child_objects_in_mc != 0) {
> 
> Like here.  Just do "if (num_child_objects_in_mc) {"

This seems to be a place that is testing for zero as a value rather than
as a stand-in for NULL, so I'd argue it's better style to leave it as
is.

-Scott


