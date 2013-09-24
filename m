Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3IXPf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:35:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64369 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3IXPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:35:23 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f5-5241b135ed37
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Joe Perches <joe@perches.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
Date: Tue, 24 Sep 2013 17:35:13 +0200
Message-id: <6100053.8DTAdONXDY@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <52418B1C.6030600@samsung.com>
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1379958282.3575.31.camel@joe-AO722> <52418B1C.6030600@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAV3TjY5BBh//GFvMvv+YxeJs0xt2
	i02Pr7FaXN41h82iZ8NWVouL6+QtTq85xWxx+E07q8X6Ga9ZLOa1v2R14PLYvKTe4+C7PUwe
	X1ZdY/bo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujB9fv7AWvHKq+P7vF0sD43/TLkZODgkB
	E4lfnW1MELaYxIV769m6GLk4hAQWMUq0dW1ngXBamCQObu1hB6liE7CSmNi+ihHEFhEwkjjS
	3sMIUsQsMItJ4vetn2AJYQFficvn74M1sAioSnS07gOaxMHBK6Ap0XhCBCQsKuAp8WnSUmYQ
	m1NAW2LewtWMEMsmM0r8Xb0VbA6vgKDEj8n3WEBsZgF5iX37p7JC2DoS+1unsU1gFJiFpGwW
	krJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOgWdSOxhXNlgcYhTgYFTi4d3h
	7RAkxJpYVlyZe4hRgoNZSYTXfINjkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Ykl
	qdmpqQWpRTBZJg5OqQZGq6VzJdlepP1W7pl/Y/2qOZtZq/NOrQx6+viMMdepnRlO0me+bTFW
	9lkTKqQVUt8sJht4LX9O/pWy67v+MPaU7Du+zbZ1a7FbIuuD299XNPL9euPPULtdx6roTNH+
	b8Y2SfNPzwnpPiKqtTXwJs8Us/8Hvlrtzknj+1C0fdKHx9Vh8SsOy11LUmIpzkg01GIuKk4E
	AIfYEVZ9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tomasz,

On Tuesday, September 24, 2013 02:52:44 PM Tomasz Stanislawski wrote:
> On 09/23/2013 07:44 PM, Joe Perches wrote:
> > On Mon, 2013-09-23 at 17:48 +0200, Bartlomiej Zolnierkiewicz wrote:
> >> On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
> >>> May I ask what is the rationale for this patch?
> >>> To reduce a few lines of code?
> >> This patch makes source code more generic-like and easier to follow (mxd_r*
> >> macros currently only obfuscate the code and make them harder to read for
> >> everybody, maybe besides the original driver author ;). Removal of few
> >> superfluous lines of code is just a bonus.
> > I don't see any significant issue with this change.
> > Using generic mechanisms is good.
> >
> 
> Hi Joe,
> Sorry for flaming but please let me explain reasons of my opposition to this patch.
> 
> 1. It is true that there was no change in mixer messages for 2.5 year in MAINLINE.
> But sometimes I used modification of mxr_ macros while testing the driver.
> Therefore those macros are useful for me.

For debug you can also trivially do this with dev_*, just #undef them in
your driver and define your versions.

> 2. The other problem with this patch is its high 'conflictness' during merging.
> Unfortunately, sometimes I have to use s5p-tv on platform and configuration
> that is only supported in older versions of the kernel + some integration patches.
> The s5p-tv differs from mainline version in those kernels. Therefore
> I would need to keep two versions of patches, one for old and another one for new kernel.

You would need to do it or not, depending on the actual change.

Anyway in the reality there is practically no development happening on
this driver. During two and half year you only did two small fixes to
the mixer driver (BTW your other drivers from s5p-tv directory are not
using any custom macros):

3c44efd [media] v4l: s5p-tv: mixer: support for dmabuf exporting
fa77521 [media] v4l: s5p-tv: mixer: support for dmabuf importing

> Or backport the 'cleanup patch' and all experimental patches above it.

The cost to backport it if/when needed should be pretty small, it is not
a big change:

 6 files changed, 78 insertions(+), 91 deletions(-)

> 3. As I understand the coding guidelines asked to use dev_* to ensure that all
> error messages have information about the device. There is no change in format of
> errors after this patch. So they do not change anything from userland point of view.

Which is actually a good thing (same functionality, less code).

> 4. I looked for other files where macro for dev_err is used.
> I tried following shell command on v3.12-rc2.
> 
> git grep -A1 "_err(" | grep -A1 '#define' | grep -B1 "dev_err"
> 
> then processing results using
> grep -v "^--" | cut -d: -f 1 | sort -u | wc
> 
> produced 55 files. Among them, the files below makes use of a macro that is
> directly expanded to dev_err(dev_ptr, fmt, ...) without any changes in format.
> 
> drivers/firewire/ohci.c
> drivers/gpu/drm/i2c/ch7006_priv.h
> drivers/gpu/drm/i2c/sil164_drv.c
> drivers/infiniband/hw/mthca/mthca_dev.h
> drivers/infiniband/hw/qib/qib.h
> drivers/media/platform/marvell-ccic/cafe-driver.c
> drivers/media/platform/marvell-ccic/mcam-core.c
> drivers/media/platform/s5p-tv/mixer.h
> drivers/media/platform/via-camera.c
> drivers/mtd/devices/docg3.h
> drivers/net/ethernet/broadcom/bgmac.h
> drivers/net/ethernet/chelsio/cxgb3/common.h
> drivers/net/ethernet/intel/e1000/e1000.h
> drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
> drivers/net/ethernet/mellanox/mlx4/mlx4.h
> drivers/net/wireless/iwlegacy/common.h
> drivers/pci/hotplug/pciehp.h
> drivers/pci/hotplug/shpchp.h
> drivers/remoteproc/ste_modem_rproc.c
> drivers/scsi/csiostor/csio_hw.h
> drivers/staging/fwserial/fwserial.c
> drivers/usb/atm/usbatm.h
> drivers/usb/host/ehci.h
> drivers/usb/host/fhci.h
> drivers/usb/host/fotg210-hcd.c
> drivers/usb/host/fusbh200-hcd.c
> drivers/usb/host/ohci.h
> drivers/usb/host/oxu210hp-hcd.c
> drivers/usb/host/xhci.h
> include/linux/hid.h
> include/net/cfg80211.h
> 
> Other files makes only cosmetic changes to format, so they might still be worth to
> be 'demacronized'. So I think we can consider that macros wrapping dev_* is still
> a widely used technique so I ask for a good reason before changing the driver.
> 
> If one still would like to continue a 'dev_* cleanup crusade' then I kindly
> ask to create a big patchset that fixes all over mentioned files.
> If most of their maintainers accepts the patches I promise to accept it in
> s5p-tv.

OK.

> Currently, due to mentioned reason the patch is not a cleanup-up for me.
> And since I am still a maintainer of this god-forgotten driver I am
> going NACK this patch because it makes my work more difficult and because
> this patch provides only (if any) relative aesthetic gain.

I won't argue about this anymore because I find the whole discussion a bit
silly. The change itself is obvious, trivial and cost to either port new
patches over it or backport it to older private trees should be very small
(as I sit next to you I know that you can handle patches effectively ;).
Lets also not forget that the mixer driver is almost dead when it comes to
new developments..

> However this patch can be saved a little. (see below)
> 
> > Few trivial nits:
> >
> > I'd remove the trailing periods from some of the messages
> > at the same time.
> >
> > Function tracing is better done by the function tracing
> > mechanism built in to the kernel.  Removing the
> > 	dev_dbg(dev, "%s: enter\n", __func__)
> > lines would be good too.
> >
> > Maybe look at the message levels of more of these
> > logging messages and determine which are actually
> > useful and what is mostly noise and should be dev_dbg
> > or deleted altogether.
> >
> 
> I agree that most of debugs in form
> 
> mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> 
> are obfuscation. So removal of such lines is a cleanup
> and provides some gain and I can ACK this kind of change.
> 
> Moreover, I agree that some mxr_info() should be changed mxr_dbg().

These sound like a good improvements.

> I ask Mateusz to modify the 'cleanup' patch to remove only useless
> mxr_dbg() and mxr_info() but to keep mxr_* macros intact.

As you wish, you're the maintainer of this driver and the mxr_* macros
issue is not worth anymore of my time..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Regards,
> Tomasz Stanislawski
> 
> >>>> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
> > 
> >>>> @@ -59,7 +59,7 @@ void mxr_streamer_get(struct mxr_device *mdev)
> >>>>  {
> >>>>  	mutex_lock(&mdev->mutex);
> >>>>  	++mdev->n_streamer;
> >>>> -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
> >>>> +	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_streamer);
> > 
> > not too useful
> > 
> > []
> > 
> >>>> @@ -159,42 +159,42 @@ static int mxr_acquire_plat_resources(struct mxr_device *mdev,
> >>>>  
> >>>>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
> >>>>  	if (res == NULL) {
> >>>> -		mxr_err(mdev, "get memory resource failed.\n");
> >>>> +		dev_err(mdev->dev, "get memory resource failed.\n");
> > 
> > 		dev_err(mdev->dev, "get memory resource failed\n");
> > etc... because of:
> > 
> >>>> @@ -252,27 +252,27 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
> >>>>  
> >>>>  	res->mixer = clk_get(dev, "mixer");
> >>>>  	if (IS_ERR(res->mixer)) {
> >>>> -		mxr_err(mdev, "failed to get clock 'mixer'\n");
> >>>> +		dev_err(mdev->dev, "failed to get clock 'mixer'\n");
> > 
> > Mixed use of messages with/without periods.
> > 
> >>>> @@ -295,13 +295,13 @@ static int mxr_acquire_resources(struct mxr_device *mdev,
> >>>>  	if (ret)
> >>>>  		goto fail_plat;
> >>>>  
> >>>> -	mxr_info(mdev, "resources acquired\n");
> >>>> +	dev_info(mdev->dev, "resources acquired\n");
> > 
> > This isn't really a useful message so I'd convert it
> > to dev_dbg
> > 
> >>>> @@ -391,7 +391,6 @@ static int mxr_probe(struct platform_device *pdev)
> >>>>  	struct mxr_device *mdev;
> >>>>  	int ret;
> >>>>  
> >>>> -	/* mdev does not exist yet so no mxr_dbg is used */
> >>>>  	dev_info(dev, "probe start\n");
> > 
> > Same with a lot of these...
> > 
> > Maybe in a separate patch.

