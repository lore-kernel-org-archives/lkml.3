Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbbAMRYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:24:54 -0500
Received: from mail-bn1bon0060.outbound.protection.outlook.com ([157.56.111.60]:4859
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751592AbbAMRYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:24:50 -0500
Date: Tue, 13 Jan 2015 09:24:36 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <michal.simek@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v5] can: Convert to runtime_pm
References: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
 <3a3437c5c8ff48d9a45fee7e81fa8dca@BY2FFO11FD058.protection.gbl>
 <54B4FCB5.6040904@pengutronix.de>
 <6ea3c0ea0f5c4deb9a6e4738a8d94a36@BN1AFFO11FD047.protection.gbl>
 <54B55326.1060606@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B55326.1060606@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21248.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1ef3e0f060f54c888061514bd2926762@BY2FFO11FD033.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377454003)(189002)(479174004)(24454002)(377424004)(51704005)(110136001)(108616004)(83506001)(106466001)(86362001)(23676002)(92566002)(85202003)(6806004)(2950100001)(92726002)(64706001)(87936001)(85182001)(50466002)(46102003)(50986999)(19580395003)(104016003)(53416004)(47776003)(74316001)(93886004)(77156002)(54356999)(62966003)(19580405001)(76176999)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB060;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB060;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB060;
X-Forefront-PRVS: 045584D28C
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB060;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 17:24:46.7671
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB060
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 06:17PM +0100, Marc Kleine-Budde wrote:
> On 01/13/2015 06:08 PM, Sören Brinkmann wrote:
> > On Tue, 2015-01-13 at 12:08PM +0100, Marc Kleine-Budde wrote:
> >> On 01/12/2015 07:45 PM, Sören Brinkmann wrote:
> >>> On Mon, 2015-01-12 at 08:34PM +0530, Kedareswara rao Appana wrote:
> >>>> Instead of enabling/disabling clocks at several locations in the driver,
> >>>> Use the runtime_pm framework. This consolidates the actions for runtime PM
> >>>> In the appropriate callbacks and makes the driver more readable and mantainable.
> >>>>
> >>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>>> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> >>>> ---
> >>>> Changes for v5:
> >>>>  - Updated with the review comments.
> >>>>    Updated the remove fuction to use runtime_pm.
> >>>> Chnages for v4:
> >>>>  - Updated with the review comments.
> >>>> Changes for v3:
> >>>>   - Converted the driver to use runtime_pm.
> >>>> Changes for v2:
> >>>>   - Removed the struct platform_device* from suspend/resume
> >>>>     as suggest by Lothar.
> >>>>
> >>>>  drivers/net/can/xilinx_can.c |  157 ++++++++++++++++++++++++++++-------------
> >>>>  1 files changed, 107 insertions(+), 50 deletions(-)
> >>> [..]
> >>>> +static int __maybe_unused xcan_runtime_resume(struct device *dev)
> >>>>  {
> >>>> -	struct platform_device *pdev = dev_get_drvdata(dev);
> >>>> -	struct net_device *ndev = platform_get_drvdata(pdev);
> >>>> +	struct net_device *ndev = dev_get_drvdata(dev);
> >>>>  	struct xcan_priv *priv = netdev_priv(ndev);
> >>>>  	int ret;
> >>>> +	u32 isr, status;
> >>>>  
> >>>>  	ret = clk_enable(priv->bus_clk);
> >>>>  	if (ret) {
> >>>> @@ -1014,15 +1030,28 @@ static int __maybe_unused xcan_resume(struct device *dev)
> >>>>  	ret = clk_enable(priv->can_clk);
> >>>>  	if (ret) {
> >>>>  		dev_err(dev, "Cannot enable clock.\n");
> >>>> -		clk_disable_unprepare(priv->bus_clk);
> >>>> +		clk_disable(priv->bus_clk);
> >>> [...]
> >>>> @@ -1173,12 +1219,23 @@ static int xcan_remove(struct platform_device *pdev)
> >>>>  {
> >>>>  	struct net_device *ndev = platform_get_drvdata(pdev);
> >>>>  	struct xcan_priv *priv = netdev_priv(ndev);
> >>>> +	int ret;
> >>>> +
> >>>> +	ret = pm_runtime_get_sync(&pdev->dev);
> >>>> +	if (ret < 0) {
> >>>> +		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> >>>> +				__func__, ret);
> >>>> +		return ret;
> >>>> +	}
> >>>>  
> >>>>  	if (set_reset_mode(ndev) < 0)
> >>>>  		netdev_err(ndev, "mode resetting failed!\n");
> >>>>  
> >>>>  	unregister_candev(ndev);
> >>>> +	pm_runtime_disable(&pdev->dev);
> >>>>  	netif_napi_del(&priv->napi);
> >>>> +	clk_disable_unprepare(priv->bus_clk);
> >>>> +	clk_disable_unprepare(priv->can_clk);
> >>>
> >>> Shouldn't pretty much all these occurrences of clk_disable/enable
> >>> disappear? This should all be handled by the runtime_pm framework now.
> >>
> >> We have:
> >> - clk_prepare_enable() in probe
> > 
> > This should become something like pm_runtime_get_sync(), shouldn't it?
> > 
> >> - clk_disable_unprepare() in remove
> > 
> > pm_runtime_put()
> > 
> >> - clk_enable() in runtime_resume
> >> - clk_disable() in runtime_suspend
> > 
> > These are the ones needed.
> > 
> > The above makes me suspect that the clocks are always on, regardless of
> 
> Define "on" :)
> The clocks are prepared after probe() exists, but not enabled. The first
> pm_runtime_get_sync() will enable the clocks.
> 
> > the runtime suspend state since they are enabled in probe and disabled
> > in remove, is that right? Ideally, the usage in probe and remove should
> > be migrated to runtime_pm and clocks should really only be running when
> > needed and not throughout the whole lifetime of the driver.
> 
> The clocks are not en/disabled via pm_runtime, because
> pm_runtime_get_sync() is called from atomic contect. We can have another
> look into the driver and try to change this.

Wasn't that why the call to pm_runtime_irq_safe() was added?
Also, clk_enable/disable should be okay to be run from atomic context.
And if the clock are already prepared after the exit of probe that
should be enough. Then remove() should just have to do the unprepare.
But I don't see why runtime_pm shouldn't be able to do the
enable/disable.

	Sören
