Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3FXRLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:11:40 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:42162 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab3FXRLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:11:39 -0400
Message-ID: <51C87DC7.50005@schinagl.nl>
Date: Mon, 24 Jun 2013 19:11:35 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130613 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl> <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl> <20130617225847.GA9494@kroah.com> <20130624092942.GG26008@lukather> <20130624160440.GA15201@kroah.com>
In-Reply-To: <20130624160440.GA15201@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,
On 06/24/13 18:04, Greg KH wrote:
> On Mon, Jun 24, 2013 at 11:29:42AM +0200, Maxime Ripard wrote:
>> Hi Greg,
>>
>> On Mon, Jun 17, 2013 at 03:58:47PM -0700, Greg KH wrote:
>>> On Mon, Jun 17, 2013 at 10:59:37PM +0200, Oliver Schinagl wrote:
>>
>> [..]
>>
>>>> +static int __init sunxi_sid_probe(struct platform_device *pdev)
>>>> +{
>>>> +	u8 entropy[SID_SIZE];
>>>> +	unsigned int i;
>>>> +	struct resource *res;
>>>> +	void __iomem *sid_reg_base;
>>>> +	int ret;
>>>> +
>>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +	sid_reg_base = devm_ioremap_resource(&pdev->dev, res);
>>>> +	if (IS_ERR(sid_reg_base))
>>>> +		return PTR_ERR(sid_reg_base);
>>>> +	platform_set_drvdata(pdev, sid_reg_base);
>>>> +
>>>> +	ret = device_create_bin_file(&pdev->dev, &sid_bin_attr);
>>>> +	if (ret)
>>>> +		return ret;
>>>
>>> You just raced with userspace, having the file show up after the device
>>> was announced to users that it was there.  Please use the proper device
>>> file api to add default attributes to prevent this from happening.
>>
>> Sorry if the question looks dumb, but what kind of race can we generate
>> here?
>
> Userspace gets told about the device from the driver core, udev runs and
> reads all of the attributes, then your probe function comes along and
> adds a new attribute.  Userspace will then not know about it at all.
>
>> The device_create_bin_file is the last call that we make (if we except
>> the entropy stuff, but it doesn't really matter here), so after we
>> created the file, we have everything properly initialised so that our
>> functions can be called, right?
>>
>> And another dumb question for you, what is the "proper device file API"
>> you are referring to ? :)
>
> Please read Documentation/driver_model/device.txt and see the section on
> Attributes for what to do.  If you have specific questions after reading
> that, please let me know.
Since Maxime kinda asked for me, I hope you don't mind me following up.

That doc doesn't mention the binary interface at all. Initially I had 
both devices up, the 'read' device as a textual representation and added 
the binary one later. Maxime and I decided the binary one made more 
sense, as the only textual user would be a human and they don't poke 
that entry that often.

So what default way exists for binary files or how would that be solved?

Oliver
>
> thanks,
>
> greg k-h
>

