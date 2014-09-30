Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaI3URT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:17:19 -0400
Received: from mail-by2on0130.outbound.protection.outlook.com ([207.46.100.130]:7744
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750978AbaI3URS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:17:18 -0400
Message-ID: <1412108227.13320.309.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
From: Scott Wood <scottwood@freescale.com>
To: Jojy Varghese <jojyv@juniper.net>
CC: Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "hongtao.jia@freescale.com" <hongtao.jia@freescale.com>
Date: Tue, 30 Sep 2014 15:17:07 -0500
In-Reply-To: <D0505C72.10E3B%jojyv@juniper.net>
References: <D0505C72.10E3B%jojyv@juniper.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:9182:1110:33a1:a006]
X-ClientProxiedBy: BL2PR05CA0047.namprd05.prod.outlook.com (10.255.226.47) To
 BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0726;
X-Forefront-PRVS: 0350D7A55D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(479174003)(199003)(377454003)(189002)(377424004)(88136002)(77156001)(85852003)(92566001)(80022003)(23676002)(110136001)(92726001)(86362001)(4396001)(42186005)(89996001)(50226001)(10300001)(87976001)(102836001)(62966002)(93916002)(33646002)(46102003)(104166001)(76482002)(103116003)(87286001)(101416001)(99396003)(1941001)(120916001)(105586002)(19580395003)(19580405001)(20776003)(95666004)(85306004)(21056001)(31966008)(47776003)(97736003)(50466002)(50986999)(76176999)(77096002)(64706001)(106356001)(107046002)(7059020)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:9182:1110:33a1:a006];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0712;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 20:15 +0000, Jojy Varghese wrote:
> 
> On 9/30/14 8:50 AM, "Guenter Roeck" <linux@roeck-us.net> wrote:
> 
> >On Mon, Sep 29, 2014 at 06:31:06PM -0500, Scott Wood wrote:
> >> Which specific chip and revision did you see this on?  What is the value
> >> in MCSR?
> >> 
> >Jojy can answer that, at least for P5020. We have seen it on P5040 as
> >well,
> >though, so it is not just limited to one chip/revision.
> 
> The specifics are:
> PVR: 0x80240012
> Instruction that causes the MC exception: lwbrx
> 	The faulty load address is also present in RB. So we could change the
> logic to use that 
> instead of DEAR. What I don’t know is of there are other cases also which
> escapes the current logic.

Could you find out what MCSR was when that happened?  I'm most
interested in whether MAV was set, but the other bits would be
interesting as well.

-Scott


