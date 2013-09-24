Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3IXMwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:52:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58348 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3IXMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:52:48 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-a4-52418b1ec51d
Message-id: <52418B1C.6030600@samsung.com>
Date: Tue, 24 Sep 2013 14:52:44 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        m.chehab@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1379775649-6331-2-git-send-email-m.krawczuk@partner.samsung.com>
 <52405519.3020504@samsung.com> <13162989.WhfDRzW6dg@amdc1032>
 <1379958282.3575.31.camel@joe-AO722>
In-reply-to: <1379958282.3575.31.camel@joe-AO722>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xa7py3Y5BBptnilpsnLGe1WL2/ccs
	Fmeb3rBbbHp8jdXi8q45bBY9G7ayWlxcJ29xes0pZovDb9pZLdbPeM3iwOWxeUm9x8F3e5g8
	vqy6xuzRt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGUun/Wcq2GNSMe3xdpYGxkXaXYycHBIC
	JhJtE28xQthiEhfurWcDsYUEljJKPPgOFOcCsj8zSsxse8ACkuAV0JL4eHAGE4jNIqAq8ffD
	PbAGNqBBx5Z8BhskKhAh8ef0PlaIekGJH5PvAfVycIgIKErc3cIPMpNZYCOTxN77vWAzhQV8
	JS6fv88OsfgHo8SKt8ogNqeAocT8re+ZQWxmAR2J/a3T2CBseYnNa94yT2AUmIVkxSwkZbOQ
	lC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERL+X3YwLj5mdYhRgINRiYf3YoJDkBBr
	YllxZe4hRgkOZiURXs1axyAh3pTEyqrUovz4otKc1OJDjEwcnFINjB4rpTaKP5/mGFJ54eM7
	//LbT7YzTWJZkn7mlYmg+wVOZakJvf7GMddmbVw//fTcV+eKH8RpvnPmdrjg3qbBtnuN/41y
	h9bUlXtUjKqaf/XKNHcca+PYcsm90m1vo+Ybz+guA5v5GZ4Pyi51vT70yzi1vefD2b1dcc8v
	J76dXpvVpWga1/jvnBJLcUaioRZzUXEiAEUbZUFdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 07:44 PM, Joe Perches wrote:
> On Mon, 2013-09-23 at 17:48 +0200, Bartlomiej Zolnierkiewicz wrote:
>> On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
>>> May I ask what is the rationale for this patch?
>>> To reduce a few lines of code?
>> This patch makes source code more generic-like and easier to follow (mxd_r*
>> macros currently only obfuscate the code and make them harder to read for
>> everybody, maybe besides the original driver author ;). Removal of few
>> superfluous lines of code is just a bonus.
> I don't see any significant issue with this change.
> Using generic mechanisms is good.
>

Hi Joe,
Sorry for flaming but please let me explain reasons of my opposition to this patch.

1. It is true that there was no change in mixer messages for 2.5 year in MAINLINE.
But sometimes I used modification of mxr_ macros while testing the driver.
Therefore those macros are useful for me.

2. The other problem with this patch is its high 'conflictness' during merging.
Unfortunately, sometimes I have to use s5p-tv on platform and configuration
that is only supported in older versions of the kernel + some integration patches.
The s5p-tv differs from mainline version in those kernels. Therefore
I would need to keep two versions of patches, one for old and another one for new kernel.
Or backport the 'cleanup patch' and all experimental patches above it.

3. As I understand the coding guidelines asked to use dev_* to ensure that all
error messages have information about the device. There is no change in format of
errors after this patch. So they do not change anything from userland point of view.

4. I looked for other files where macro for dev_err is used.
I tried following shell command on v3.12-rc2.

git grep -A1 "_err(" | grep -A1 '#define' | grep -B1 "dev_err"

then processing results using
grep -v "^--" | cut -d: -f 1 | sort -u | wc

produced 55 files. Among them, the files below makes use of a macro that is
directly expanded to dev_err(dev_ptr, fmt, ...) without any changes in format.

drivers/firewire/ohci.c
drivers/gpu/drm/i2c/ch7006_priv.h
drivers/gpu/drm/i2c/sil164_drv.c
drivers/infiniband/hw/mthca/mthca_dev.h
drivers/infiniband/hw/qib/qib.h
drivers/media/platform/marvell-ccic/cafe-driver.c
drivers/media/platform/marvell-ccic/mcam-core.c
drivers/media/platform/s5p-tv/mixer.h
drivers/media/platform/via-camera.c
drivers/mtd/devices/docg3.h
drivers/net/ethernet/broadcom/bgmac.h
drivers/net/ethernet/chelsio/cxgb3/common.h
drivers/net/ethernet/intel/e1000/e1000.h
drivers/net/ethernet/intel/ixgbe/ixgbe_common.h
drivers/net/ethernet/mellanox/mlx4/mlx4.h
drivers/net/wireless/iwlegacy/common.h
drivers/pci/hotplug/pciehp.h
drivers/pci/hotplug/shpchp.h
drivers/remoteproc/ste_modem_rproc.c
drivers/scsi/csiostor/csio_hw.h
drivers/staging/fwserial/fwserial.c
drivers/usb/atm/usbatm.h
drivers/usb/host/ehci.h
drivers/usb/host/fhci.h
drivers/usb/host/fotg210-hcd.c
drivers/usb/host/fusbh200-hcd.c
drivers/usb/host/ohci.h
drivers/usb/host/oxu210hp-hcd.c
drivers/usb/host/xhci.h
include/linux/hid.h
include/net/cfg80211.h

Other files makes only cosmetic changes to format, so they might still be worth to
be 'demacronized'. So I think we can consider that macros wrapping dev_* is still
a widely used technique so I ask for a good reason before changing the driver.

If one still would like to continue a 'dev_* cleanup crusade' then I kindly
ask to create a big patchset that fixes all over mentioned files.
If most of their maintainers accepts the patches I promise to accept it in
s5p-tv.

Currently, due to mentioned reason the patch is not a cleanup-up for me.
And since I am still a maintainer of this god-forgotten driver I am
going NACK this patch because it makes my work more difficult and because
this patch provides only (if any) relative aesthetic gain.

However this patch can be saved a little. (see below)

> Few trivial nits:
>
> I'd remove the trailing periods from some of the messages
> at the same time.
>
> Function tracing is better done by the function tracing
> mechanism built in to the kernel.  Removing the
> 	dev_dbg(dev, "%s: enter\n", __func__)
> lines would be good too.
>
> Maybe look at the message levels of more of these
> logging messages and determine which are actually
> useful and what is mostly noise and should be dev_dbg
> or deleted altogether.
>

I agree that most of debugs in form

mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);

are obfuscation. So removal of such lines is a cleanup
and provides some gain and I can ACK this kind of change.

Moreover, I agree that some mxr_info() should be changed mxr_dbg().
I ask Mateusz to modify the 'cleanup' patch to remove only useless
mxr_dbg() and mxr_info() but to keep mxr_* macros intact.

Regards,
Tomasz Stanislawski

>>>> diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
> 
>>>> @@ -59,7 +59,7 @@ void mxr_streamer_get(struct mxr_device *mdev)
>>>>  {
>>>>  	mutex_lock(&mdev->mutex);
>>>>  	++mdev->n_streamer;
>>>> -	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
>>>> +	dev_dbg(mdev->dev, "%s(%d)\n", __func__, mdev->n_streamer);
> 
> not too useful
> 
> []
> 
>>>> @@ -159,42 +159,42 @@ static int mxr_acquire_plat_resources(struct mxr_device *mdev,
>>>>  
>>>>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
>>>>  	if (res == NULL) {
>>>> -		mxr_err(mdev, "get memory resource failed.\n");
>>>> +		dev_err(mdev->dev, "get memory resource failed.\n");
> 
> 		dev_err(mdev->dev, "get memory resource failed\n");
> etc... because of:
> 
>>>> @@ -252,27 +252,27 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
>>>>  
>>>>  	res->mixer = clk_get(dev, "mixer");
>>>>  	if (IS_ERR(res->mixer)) {
>>>> -		mxr_err(mdev, "failed to get clock 'mixer'\n");
>>>> +		dev_err(mdev->dev, "failed to get clock 'mixer'\n");
> 
> Mixed use of messages with/without periods.
> 
>>>> @@ -295,13 +295,13 @@ static int mxr_acquire_resources(struct mxr_device *mdev,
>>>>  	if (ret)
>>>>  		goto fail_plat;
>>>>  
>>>> -	mxr_info(mdev, "resources acquired\n");
>>>> +	dev_info(mdev->dev, "resources acquired\n");
> 
> This isn't really a useful message so I'd convert it
> to dev_dbg
> 
>>>> @@ -391,7 +391,6 @@ static int mxr_probe(struct platform_device *pdev)
>>>>  	struct mxr_device *mdev;
>>>>  	int ret;
>>>>  
>>>> -	/* mdev does not exist yet so no mxr_dbg is used */
>>>>  	dev_info(dev, "probe start\n");
> 
> Same with a lot of these...
> 
> Maybe in a separate patch.
> 
> 
> 
> 

