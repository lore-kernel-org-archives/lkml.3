Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaLQJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:38:32 -0500
Received: from mail-bn1bn0104.outbound.protection.outlook.com ([157.56.110.104]:15168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbaLQJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:38:14 -0500
X-WSS-ID: 0NGQ03K-07-ZIY-02
X-M-MSG: 
Message-ID: <1418808453.2582.36.camel@kxue-X58A-UD3R>
Subject: Re: [PATCH 3/3] acpi:lpss:Refine lpss codes to fit acpi soc.
From: Ken Xue <Ken.Xue@amd.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: <rjw@rjwysocki.net>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>
Date: Wed, 17 Dec 2014 17:27:33 +0800
In-Reply-To: <20141216101626.GW1300@lahna.fi.intel.com>
References: <1418267151-5650-1-git-send-email-Ken.Xue@amd.com>
	 <20141216101626.GW1300@lahna.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(54534003)(377424004)(24454002)(199003)(51704005)(189002)(50466002)(19580395003)(19580405001)(87936001)(4396001)(50226001)(33716001)(89996001)(20776003)(64706001)(47776003)(77096005)(68736005)(107046002)(97736003)(2950100001)(23676002)(31966008)(92566001)(21056001)(86362001)(33646002)(106466001)(105586002)(110136001)(50986999)(76176999)(62966003)(103116003)(101416001)(46102003)(77156002)(84676001)(99396003)(120916001)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB193;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2014 09:38:11.2096
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 12:16 +0200, Mika Westerberg wrote:
> On Thu, Dec 11, 2014 at 11:05:51AM +0800, Ken Xue wrote:
> 
> This is missing changelog.
> 
> > Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> 
> ...
> 
[Ken]got it.

> > +static int lpss_common_setup(struct acpi_soc_dev_private_data *pdata)
> >  {
> > -	struct lpss_device_desc *dev_desc;
> > -	struct lpss_private_data *pdata;
> > -	struct resource_list_entry *rentry;
> > -	struct list_head resource_list;
> > -	struct platform_device *pdev;
> > -	int ret;
> > -
> > -	dev_desc = (struct lpss_device_desc *)id->driver_data;
> > -	if (!dev_desc) {
> > -		pdev = acpi_create_platform_device(adev);
> > -		return IS_ERR_OR_NULL(pdev) ? PTR_ERR(pdev) : 1;
> > -	}
> > -	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> > -	if (!pdata)
> > -		return -ENOMEM;
> > -
> > -	INIT_LIST_HEAD(&resource_list);
> > -	ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
> > -	if (ret < 0)
> > -		goto err_out;
> > -
> > -	list_for_each_entry(rentry, &resource_list, node)
> > -		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> > -			if (dev_desc->prv_size_override)
> > -				pdata->mmio_size = dev_desc->prv_size_override;
> > -			else
> > -				pdata->mmio_size = resource_size(&rentry->res);
> > -			pdata->mmio_base = ioremap(rentry->res.start,
> > -						   pdata->mmio_size);
> > -			break;
> > -		}
> > -
> > -	acpi_dev_free_resource_list(&resource_list);
> > +	int ret = 0;
> > +	struct acpi_soc_dev_desc *dev_desc;
> 
> 
> Please order these so that the longest line is on top. E.g
> 
[ken]got it.

> 	struct acpi_soc_dev_desc *dev_desc;
> 	int ret = 0;
> 
> Ditto for other similar places.
> 
> >  
> > -	pdata->dev_desc = dev_desc;
> > +	dev_desc = pdata->dev_desc;
> >  
> > -	if (dev_desc->setup)
> > -		dev_desc->setup(pdata);
> > +	if (dev_desc->flags & LPSS_CLK)
> > +		ret = register_device_clock(pdata->adev, pdata);
> >  
> > -	if (dev_desc->flags & LPSS_CLK) {
> > -		ret = register_device_clock(adev, pdata);
> > -		if (ret) {
> > -			/* Skip the device, but continue the namespace scan. */
> > -			ret = 0;
> > -			goto err_out;
> > -		}
> > -	}
> > +	return ret;
> > +}
> 
> ...
> 
> >  void __init acpi_lpss_init(void)
> >  {
> >  	if (!lpt_clk_init()) {
> > -		bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
> > -		acpi_scan_add_handler(&lpss_handler);
> > +		a_soc.ids = acpi_lpss_device_ids;
> > +		a_soc.attr_group = &lpss_attr_group;
> > +		a_soc.pm_domain = &acpi_lpss_pm_domain;
> 
> If AMD stuff is not needing PM domain or LTR, I suggest that you leave
> both to be part of LPSS and not move them to acpi_soc.
> 
[Ken]there is no strong reason i can see to remove it. AMD may be also
has similar good feature in the future. and intel also can modify acpi
soc as you need, if it really can not meet your design. 

> > +		register_acpi_soc(&a_soc, true);
>                                           ^^^^ This needs to be false
> 
> >  	}
> >  }


