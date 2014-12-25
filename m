Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaLYDMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 22:12:00 -0500
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:53580
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692AbaLYDL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 22:11:59 -0500
Date: Thu, 25 Dec 2014 10:03:02 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: Sanchayan Maity <maitysanchayan@gmail.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: chipidea: Add identification registers access
 APIs
Message-ID: <20141225020259.GA5077@shlinux2>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
 <72124df17c0f40f8a7ae02faa9664b9d51743584.1418981438.git.maitysanchayan@gmail.com>
 <4f5efe169ed3ab16ffcbee52dd6b7661@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4f5efe169ed3ab16ffcbee52dd6b7661@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(51704005)(24454002)(377424004)(85426001)(46406003)(19580395003)(6806004)(19580405001)(33656002)(46102003)(33716001)(21056001)(23726002)(106466001)(92566001)(97756001)(97736003)(83506001)(47776003)(20776003)(4396001)(64706001)(31966008)(107046002)(87936001)(50986999)(54356999)(77096005)(68736005)(110136001)(76176999)(50466002)(86362001)(105606002)(84676001)(62966003)(77156002)(104016003)(120916001)(2950100001)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB214;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB214;
X-Forefront-PRVS: 04362AC73B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2014 03:11:54.8560
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 05:00:05PM +0100, Stefan Agner wrote:
> On 2014-12-19 10:55, Sanchayan Maity wrote:
> > Using hw_write_id_reg and hw_read_id_reg to write and read
> > identification registers contents. This can be used to get
> > controller information, change some system configurations
> > and so on.
> 
> Checkpatch is complaining about DOS line endings and some trailing
> whitespace. This applies to all three patches.
> 
> > 
> > Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> > ---
> >  drivers/usb/chipidea/ci.h |   53 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> > 
> > diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> > index ea40626..94db636 100644
> > --- a/drivers/usb/chipidea/ci.h
> > +++ b/drivers/usb/chipidea/ci.h
> > @@ -29,6 +29,15 @@
> >  /******************************************************************************
> >   * REGISTERS
> >   *****************************************************************************/
> > +/* Identification Registers */
> > +#define ID_ID				0x0
> > +#define ID_HWGENERAL			0x4
> > +#define ID_HWHOST			0x8
> > +#define ID_HWDEVICE			0xc
> > +#define ID_HWTXBUF			0x10
> > +#define ID_HWRXBUF			0x14
> > +#define ID_SBUSCFG			0x90
> > +
> >  /* register indices */
> >  enum ci_hw_regs {
> >  	CAP_CAPLENGTH,
> > @@ -97,6 +106,18 @@ enum ci_role {
> >  	CI_ROLE_END,
> >  };
> >  
> > +enum CI_REVISION {
> 
> Usually the enum names are small caps, only the labels are capitalized.
> I would suggest use ci_revision here (similar to the enum above).

I will change it.

> 
> > +	CI_REVISION_1X = 10,	/* Revision 1.x */
> > +	CI_REVISION_20 = 20, /* Revision 2.0 */
> > +	CI_REVISION_21, /* Revision 2.1 */
> > +	CI_REVISION_22, /* Revision 2.2 */
> > +	CI_REVISION_23, /* Revision 2.3 */
> > +	CI_REVISION_24, /* Revision 2.4 */
> > +	CI_REVISION_25, /* Revision 2.5 */
> > +	CI_REVISION_25_PLUS, /* Revision above than 2.5 */
> > +	CI_REVISION_UNKNOWN = 99, /* Unknown Revision */
> > +};
> > +
> >  /**
> >   * struct ci_role_driver - host/gadget role driver
> >   * @start: start this role
> > @@ -168,6 +189,7 @@ struct hw_bank {
> >   * @b_sess_valid_event: indicates there is a vbus event, and handled
> >   * at ci_otg_work
> >   * @imx28_write_fix: Freescale imx28 needs swp instruction for writing
> > + * @rev: The revision number for controller
> >   */
> >  struct ci_hdrc {
> >  	struct device			*dev;
> > @@ -207,6 +229,7 @@ struct ci_hdrc {
> >  	bool				id_event;
> >  	bool				b_sess_valid_event;
> >  	bool				imx28_write_fix;
> > +	enum CI_REVISION		rev;
> >  };
> >  
> >  static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
> > @@ -244,6 +267,36 @@ static inline void ci_role_stop(struct ci_hdrc *ci)
> >  }
> >  
> >  /**
> > + * hw_read_id_reg: reads from a identification register
> > + * @ci: the controller
> > + * @offset: offset from the beginning of identification registers region
> > + * @mask: bitfield mask
> > + *
> > + * This function returns register contents
> > + */
> > +static inline u32 hw_read_id_reg(struct ci_hdrc *ci, u32 offset, u32 mask)
> > +{
> > +	return ioread32(ci->hw_bank.abs + offset) & mask;
> > +}
> > +
> > +/**
> > + * hw_write_id_reg: writes to a identification register
> > + * @ci: the controller
> > + * @offset: offset from the beginning of identification registers region
> > + * @mask: bitfield mask
> > + * @data: new value
> > + */
> > +static inline void hw_write_id_reg(struct ci_hdrc *ci, u32 offset,
> > +			    u32 mask, u32 data)
> > +{
> > +	if (~mask)
> > +		data = (ioread32(ci->hw_bank.abs + offset) & ~mask)
> > +			| (data & mask);
> > +
> > +	iowrite32(data, ci->hw_bank.abs + offset);
> > +}
> 
> This function isn't used anywhere, does it make sense to write an ID
> register? The ones I see in Vybrid's RM are read-only anyway..
> 

This API is used to write identification registers (offset, 0x00 - 0x90),
not only the ID register, the SBUSCFG (offset 0x90) attribute is read/write.

-- 

Best Regards,
Peter Chen
