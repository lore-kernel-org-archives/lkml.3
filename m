Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab3FQMvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:51:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47893 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3FQMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:51:37 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-86-51bf0656b609
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux@arm.linux.org.uk,
        arnd@arndb.de, Oliver Schinagl <oliver@schinagl.nl>,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        maxime.ripard@free-electrons.com
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Date: Mon, 17 Jun 2013 14:51:27 +0200
Message-id: <1894396.Y9rMOhn2P3@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.3 (Linux/3.8.8-gentoo; KDE/4.10.3; x86_64; ; )
In-reply-to: <51BEE6BF.30401@schinagl.nl>
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl>
 <2828921.i3T9JhMInt@flatron> <51BEE6BF.30401@schinagl.nl>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xq7phbPsDDb5NV7J4OeEwo8XfScfY
	LZoXr2ezmPJnOZPFpsfXWC0u75rDZnH7Mq/F1k17mS1eTLjDaPFy0kNWi1W7/jA6cHu0NPew
	efz+NYnR48mmi4weO2fdZfe4c20Pm8f+uWvYPTYvqfdobVnO6vF5k1wAZxSXTUpqTmZZapG+
	XQJXxoqPK5kLrpVVNE37ytTA+Dm6i5GTQ0LAROL55BNMELaYxIV769m6GLk4hASWMkpc/jiP
	CcLpYpI49HAOWBWbgJrE54ZHbCC2iICGxJSux+wgRcwCO5gkFnyZBpYQFvCS6J6ygxnEZhFQ
	lfj99T+YzSugKTFv6y5GEJtfQF3i3banYENFBVwl3q8+zAJicwLVdK2+zAKxuZlRorfhPBtE
	s6DEj8n3wIqYBeQl9u2fygpha0ms33mcaQKj4CwkZbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFe
	cWJucWleul5yfu4mRkg8fdnBuPiY1SFGAQ5GJR7eDdX7AoVYE8uKK3MPMUpwMCuJ8MZOBArx
	piRWVqUW5ccXleakFh9iZOLglGpgjF9QuEot5PoVg9czFCUD3x1LYHzK9u743rNfL8/ycK30
	X/myc1vCoWXGjTG++gs2/HPquTIhwX6TVurtOwwG6/+7H9aMN5SNzP4T+0SbJTzpzEXxBW/m
	VmyQZuktWK+3Iy3864TG+hsc1w5/nWPacv5IFFNVSbdXqalCxa3+v9+n9EpvXLbuoxJLcUai
	oRZzUXEiAHKiz4SFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 of June 2013 12:36:47 Oliver Schinagl wrote:
> On 15-06-13 12:28, Tomasz Figa wrote:
> > Hi,
> > 
> > Some comments inline.
> 
> Thank you

You're welcome. :)

> > On Saturday 15 of June 2013 01:16:20 Oliver Schinagl wrote:
> >> From: Oliver Schinagl <oliver@schinagl.nl>
> >> 
> >> Allwinner has electric fuses (efuse) on their line of chips. This driver
> >> reads those fuses, seeds the kernel entropy and exports them as a sysfs
> >> node.
> >> 
> >> These fuses are most likly to be programmed at the factory, encoding
> >> things like Chip ID, some sort of serial number etc and appear to be
> >> reasonable unique.
> >> While in theory, these should be writeable by the user, it will probably
> >> be inconvinient to do so. Allwinner recommends that a certain input
> >> pin, labeled 'efuse_vddq', be connected to GND. To write these fuses,
> >> 2.5 V needs to be applied to this pin.
> >> 
> >> Even so, they can still be used to generate a board-unique mac from,
> >> board unique RSA key and seed the kernel RNG.
> >> 
> >> Currently supported are the following known chips:
> >> Allwinner sun4i (A10)
> >> Allwinner sun5i (A10s, A13)
> >> 
> >> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> >> ---
> >> 
> >>   drivers/misc/eeprom/Kconfig     |  17 ++++
> >>   drivers/misc/eeprom/Makefile    |   1 +
> >>   drivers/misc/eeprom/sunxi_sid.c | 167
> >> 
> >> ++++++++++++++++++++++++++++++++++++++++ 3 files changed, 185
> >> insertions(+)
> >> 
> >>   create mode 100644 drivers/misc/eeprom/sunxi_sid.c
> >> 
> >> diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
> >> index 04f2e1f..c7bc6ed 100644
> >> --- a/drivers/misc/eeprom/Kconfig
> >> +++ b/drivers/misc/eeprom/Kconfig
> >> @@ -96,4 +96,21 @@ config EEPROM_DIGSY_MTC_CFG
> >> 
> >>   	  If unsure, say N.
> >> 
> >> +config EEPROM_SUNXI_SID
> >> +	tristate "Allwinner sunxi security ID support"
> >> +	depends on ARCH_SUNXI && SYSFS
> >> +	help
> >> +	  This is a driver for the 'security ID' available on various
> >> Allwinner +	  devices. Currently supported are:
> >> +		sun4i (A10)
> >> +		sun5i (A13)
> >> +
> >> +	  Due to the potential risks involved with changing e-fuses,
> >> +	  this driver is read-only
> >> +
> >> +	  For more information visit http://linux-sunxi.org/SID
> >> +
> >> +	  This driver can also be built as a module. If so, the module
> >> +	  will be called sunxi_sid.
> >> +
> >> 
> >>   endmenu
> >> 
> >> diff --git a/drivers/misc/eeprom/Makefile b/drivers/misc/eeprom/Makefile
> >> index fc1e81d..9507aec 100644
> >> --- a/drivers/misc/eeprom/Makefile
> >> +++ b/drivers/misc/eeprom/Makefile
> >> @@ -4,4 +4,5 @@ obj-$(CONFIG_EEPROM_LEGACY)	+= eeprom.o
> >> 
> >>   obj-$(CONFIG_EEPROM_MAX6875)	+= max6875.o
> >>   obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
> >>   obj-$(CONFIG_EEPROM_93XX46)	+= eeprom_93xx46.o
> >> 
> >> +obj-$(CONFIG_EEPROM_SUNXI_SID)	+= sunxi_sid.o
> >> 
> >>   obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
> >> 
> >> diff --git a/drivers/misc/eeprom/sunxi_sid.c
> >> b/drivers/misc/eeprom/sunxi_sid.c new file mode 100644
> >> index 0000000..f014e1b
> >> --- /dev/null
> >> +++ b/drivers/misc/eeprom/sunxi_sid.c
> >> @@ -0,0 +1,167 @@
> >> +/*
> >> + * Copyright (c) 2013 Oliver Schinagl
> >> + * http://www.linux-sunxi.org
> >> + *
> >> + * Oliver Schinagl <oliver@schinagl.nl>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> by + * the Free Software Foundation; either version 2 of the License,
> >> or + * (at your option) any later version.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * This driver exposes the Allwinner security ID, a 128 bit eeprom, in
> >> byte + * sized chunks.
> >> + */
> >> +
> >> +#include <linux/compiler.h>
> >> +#include <linux/device.h>
> >> +#include <linux/err.h>
> >> +#include <linux/errno.h>
> >> +#include <linux/export.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/init.h>
> >> +#include <linux/io.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/kobject.h>
> >> +#include <linux/module.h>
> >> +#include <linux/of_address.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/random.h>
> >> +#include <linux/stat.h>
> >> +#include <linux/sysfs.h>
> >> +#include <linux/types.h>
> >> +
> >> +#define DRV_NAME "sunxi-sid"
> >> +#define DRV_VERSION "1.0"
> > 
> > What is this version thingy?
> > 
> > Is there a versioning scheme defined for this driver? Do you expect it to
> > be changed every modification of this driver?
> > 
> > I don't see any point of having such thing in a project with a version
> > control system, where you have all change history.
> 
> Well we export something to userspace, while trivial there is the
> possibility it changes over time. Say A40 which outputs 256 bits instead
> of the current 128 bits. That would validate a bump in version number.
> It's purely so the user can be aware of differences in the driver. So
> maybe DRV_A[BP]I_VERSION would be better?
> 
> >> +
> >> +/* There are 4 32-bit keys */
> >> +#define SID_KEYS 4
> >> +/* and 4 byte sized keys per 32-bit key */
> >> +#define SID_SIZE (SID_KEYS * 4)
> >> 
> >  From this definition it looks like there are just 4 32-bit keys, I don't
> > 
> > see those extra four byte-sized keys accounted by this size.
> 
> I will change the comment, 'and 4 byte sized keys per SID' is probably
> better
> The array is 128 bits split into 32 bit words. Each 32 bit word consists
> of 8 bits (1 byte).
> So 4 * 4 = 16 bytes (SID_SIZE), is 128 bits.
> 

What about:

	/* There are 4 keys. */
	#define SID_KEYS 4
	/* Each key is 4 byte long (32-bit). */
	#define SID_SIZE (SID_KEYS * 4)

> >> +
> >> +
> > 
> > One _empty_ line is enough to separate definitions from code.
> 
> Okay, I find it personally a little clearer to separate them, but sure.
> 
> >> +/* We read the entire key, but only return the requested byte. This is
> >> of + * course slower then it could be and uses 4 times more reads as
> >> needed but + * keeps code simpler.
> > 
> > I have no idea how often this is going to be read, but since the whole sid
> > is really small (16 bytes), maybe it would be better to simply read the ID
> > in probe to a buffer and then just memcpy from it in read().
> 
> The sid will be read once (well all 16 bytes) during probe and after
> that only on user request. Right now we don't have a user (yet) other
> then the sysfs entry.
> 
> In future, this key can be used to read the MAC (low reads) or AES keys
> for example (also low reads).
> 
> Initially I had such an approach, but Maxime recommended against having
> the value cached.
> 
> As I wrote to andy, the only 'more efficient' way would be to store the
> previously read key and see on the next read if its the same, So best
> case, we could save 4 reads. I think it makes the code unnecessarily
> complex for something that is read so little.

OK. If it's not to be read too often then it's fine.

> >> + */
> >> +static u8 sunxi_sid_read_byte(const void __iomem *sid_reg_base,
> >> +			      const unsigned int offset)
> >> +{
> >> +	u32 sid_key = 0;
> >> 
> > 	u32 sid_key; ...
> 
> Indeed, a left over from a previous version. It does no longer need to
> be initted.
> 
> >> +
> >> +	if (offset >= SID_SIZE)
> >> +		goto exit;
> >> 
> > 		return 0; ...
> 
> I did say in the changelog I opted for goto over return. But since
> everybody keeps preferring returns (I personally like 'one single exit
> point much more' I have already changed it all over to many returns, who
> am I to argue :)

Well, single exit points makes sense (and is much nicer) when you have 
something to do before exiting, take error paths as an example. But jumping 
just to return makes no sense, because when reading the code you must scroll 
down to the label to check what actually happens.

> >> +
> >> +	sid_key = ioread32be(sid_reg_base + round_down(offset, 4));
> >> +	sid_key >>= (offset % 4) * 8;
> >> +	sid_key &= 0xff;
> >> +	/* fall through */
> >> +
> > 
> >> +exit:
> > ...and now magically here you can remove two unneeded lines.
> > 
> >> +	return (u8)sid_key;
> > 
> > Unnecessary casting.
> 
> Unnecessary because of the &= 0xff above, or because you can put a 32bit
> int in an 8bit int without worries? (we only want the last byte).
> 
> >> +}
> >> +
> >> +static ssize_t sid_read(struct file *fd, struct kobject *kobj,
> >> +			struct bin_attribute *attr, char *buf,
> >> +			loff_t pos, size_t size)
> >> +{
> >> +	int i;
> >> +	struct platform_device *pdev;
> >> +	void __iomem *sid_reg_base;
> >> +
> >> +	pdev = (struct platform_device
> >> *)to_platform_device(kobj_to_dev(kobj)); +	sid_reg_base = (void
> > 
> > __iomem
> > 
> >> *)platform_get_drvdata(pdev);
> >> +
> >> +	for (i = 0; i < size; i++) {
> >> +		if ((pos + i) >= SID_SIZE || (pos < 0))
> >> +			break;
> >> +		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
> >> +	}
> > 
> > This could be greatly simplified if you just read the whole sid to memory
> > in probe and memcpy from it here.
> 
> But can't because we don't want to cache it.
> 
> >> +	return i;
> >> +}
> >> +
> >> +static const struct of_device_id sunxi_sid_of_match[] = {
> >> +	{
> >> +		.compatible = "allwinner,sun4i-sid",
> >> +	},
> > 
> > Above 3 lines could be put in single line.
> 
> okay
> 
> >> +	{/* sentinel */}
> >> +};
> >> +MODULE_DEVICE_TABLE(of, sunxi_sid_of_match);
> >> +
> >> +static const struct bin_attribute sid_bin_attr = {
> >> +	.attr = {
> >> +		.name = "eeprom",
> >> +		.mode = S_IRUGO,
> >> +	},
> >> +	.size = SID_SIZE,
> >> +	.read = sid_read,
> >> +};
> >> +
> >> +static int sunxi_sid_remove(struct platform_device *pdev)
> >> +{
> >> +	device_remove_bin_file(&pdev->dev, &sid_bin_attr);
> >> +	dev_info(&pdev->dev, "sunxi SID driver unloaded\n");
> > 
> > Please either make this dev_dbg or remove it completely, as it is not
> > something that users should be concerned about.
> 
> dev_dbg might be better for the remove, thanks
> 
> >> +	return 0;
> >> +}
> >> +
> >> +static int __init sunxi_sid_probe(struct platform_device *pdev)
> >> +{
> >> +	int entropy[SID_SIZE], i;
> >> +	struct resource *res;
> >> +	void __iomem *sid_reg_base;
> >> +	int ret;
> >> +
> >> +	if (!pdev->dev.of_node) {
> >> +		dev_err(&pdev->dev, "No devicetree data available\n");
> >> +		ret = -ENXIO;
> >> +		goto exit;
> >> +	}
> > 
> > What is this check for? You don't seem to need anything from dev.of_node
> > in this driver.
> 
> My understanding was, that when using the device tree, we check if the
> device tree is atleast available. And we use platform_get_resource,
> doesn't that get the data from the device tree?

When you call platform_get_resource(), it looks at platform_device you pass to 
it and takes all resources from an array that is generated early at bootup (in 
case when DT is available). It will return an error pointer if there is no 
resource satisfying your requirements in this array.

In addition devm_ioremap_resource() checks the resource pointer, so if it's an 
error pointer it will print a message and return an error as well.

> >> +
> >> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
> >> +	if (IS_ERR(sid_reg_base)) {
> >> +		ret = PTR_ERR(sid_reg_base);
> >> +		goto exit;
> >> +	}
> > 
> > One of the points of having devm_ helpers was removing the need to use
> > error paths at functions end. You can save 2 lines of code by changing
> > 
> > this check to:
> > 	if (IS_ERR(sid_reg_base))
> > 	
> > 		return PTR_ERR(sid_reg_base);
> 
> Okay
> 
> >> +	platform_set_drvdata(pdev, sid_reg_base);
> >> +
> >> +	ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
> >> +	if (ret) {
> >> +		dev_err(&pdev->dev, "Unable to create sysfs bin entry\n");
> >> +		goto exit;
> >> +	}
> > 
> > Same here.
> 
> Yeah, many returns, check
> 
> >> +
> >> +	for (i = 0; i < SID_SIZE; i++)
> >> +		entropy[i] = sunxi_sid_read_byte(sid_reg_base, i);
> > 
> > You seem to read bytes into an array of ints. Your entropy data will
> > always have most significant 24-bits cleared. Is this behavior correct?
> 
> Yes, though I changed it so that entropy is an array of u8's, since
> that's what sunxi_sid_read_byte returns.
> 
> >> +	add_device_randomness(entropy, SID_SIZE);
> > 
> > Now I'm pretty sure that above is not the correct behavior. You are adding
> > here first 16 bytes (=SID_SIZE) of entropy[], while it is an array of 16
> > ints (=4*SID_SIZE)...
> 
> Well technically, doesn't to compiler see that entropy is never larger
> then 8 bits and thus uses only 8 bits? uint8_atleast or something. But
> yeah, it's better to use the specified size to not waste 24 empty bits.

I mean, the loop fills the array with SID_SIZE ints, each with 3 zero bytes and 
1 byte of actual data, so you get:

S0 0x00 0x00 0x00 S1 0x00 0x00 0x00 ... S15 0x00 0x00 0x00

but by calling add_device_randomness() with SID_SIZE as size argument, you add 
only 16 first bytes of data from the array:

S0 0x00 0x00 0x00 S1 0x00 0x00 0x00 ... S3 0x00 0x00 0x00

(little endianness assumed)

Best regards,
Tomasz

(for rest of comments I think it's enough said in Russell's and Maxime's 
replies)

> >> +	dev_info(&pdev->dev, "sunxi SID ver %s loaded\n", DRV_VERSION);
> > 
> > Same comment as for the message in remove().
> 
> Though with the DRV_(A[BP]I_)VERSION this is purly informational, I
> changed it to only show in the dev_dbg as requested.
> 
> >> +	ret = 0;
> >> +	/* fall through */
> >> +
> >> +exit:
> >> +	return ret;
> > 
> > Above 4 non-empty lines can be replaced by a single
> > 
> > 	return 0;
> > 	
> >> +}
> >> +
> >> +static struct platform_driver sunxi_sid_driver = {
> >> +	.probe = sunxi_sid_probe,
> >> +	.remove = sunxi_sid_remove,
> >> +	.driver = {
> >> +		.name = DRV_NAME,
> >> +		.owner = THIS_MODULE,
> >> +		.of_match_table = sunxi_sid_of_match,
> >> +	},
> >> +};
> >> +module_platform_driver(sunxi_sid_driver);
> >> +
> >> +
> > 
> > One empty line is enough.
> 
> Okay
> 
> > Best regards,
> > Tomasz
> > 
> >> +MODULE_AUTHOR("Oliver Schinagl <oliver@schinagl.nl>");
> >> +MODULE_DESCRIPTION("Allwinner sunxi security id driver");
> >> +MODULE_VERSION(DRV_VERSION);
> >> +MODULE_LICENSE("GPL");
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
