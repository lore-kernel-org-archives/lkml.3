Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbaLIPIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:08:37 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16060 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaLIPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:08:35 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b2-548710715394
Message-id: <5487105F.5000003@samsung.com>
Date: Tue, 09 Dec 2014 16:08:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v9 04/19] mfd: max77693: adjust
 max77693_led_platform_data
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-5-git-send-email-j.anaszewski@samsung.com>
 <20141209085047.GR3951@x1> <5486BC44.7010602@samsung.com>
 <20141209100413.GW3951@x1> <5486CE1F.9010102@samsung.com>
 <20141209135017.GY3951@x1> <548700DE.2050208@samsung.com>
 <20141209144100.GA3951@x1>
In-reply-to: <20141209144100.GA3951@x1>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Vd1CgfYQg9efZC02zljPanF050Qm
	i+tfnrNa9L9ZyGpx7tVKRoveq88ZLc42vWG3uP/1KKPF5V1z2Cy2vlnHaNGzYSurxdLrF5ks
	7p46ymYxYfpaFovWvUfYLXbvespqcWb/SjYHQY8189Ywelzu62Xy2DnrLrvHyuVf2DwOf13I
	4rFpVSebx51re9g89sz/werRt2UVo8eK1d/ZPT5vkgvgjuKySUnNySxLLdK3S+DKuLa8lb3g
	j0TFlmc32BoY20W6GDk5JARMJLq/3mCCsMUkLtxbz9bFyMUhJLCUUWLRtbOsEM4nIOf5HGaQ
	Kl4BLYmLly6AdbAIqEosbn7CDmKzCRhK9B7tYwSxRQUiJE7e3cMOUS8o8WPyPRYQW0QgWGLT
	nLuMIEOZBX4zSfxvuQTWICwQIrHh2XxmiG03mCR+X7vOCpLgFFCX+D1xGdAkDqAOdYkpU3JB
	wswC8hKb17xlnsAoMAvJjlkIVbOQVC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERKH
	X3cwLj1mdYhRgINRiYd3h2JbiBBrYllxZe4hRgkOZiUR3rUs7SFCvCmJlVWpRfnxRaU5qcWH
	GJk4OKUaGBO72kQXdMiovzu+KOxYZPXfALOSC2Hr9KyvZpftWqz687ugrHHqXfk/m86mP8h8
	PG9X6gp3n3MnIrm/vqia0TRp6b/H7BfT+/MZDQyNfO11bt0S3XXyon4H++6wyv03X0kLLA3f
	IbP33M7Ilk9xntZTN2rcuhi4LdLbJkjHzXqjdkfl8YXWO5VYijMSDbWYi4oTAdUeZlqhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/14 15:41, Lee Jones wrote:
>>>>>>>> struct max77693_led_platform_data {
>>>>>>>> > >>>>>>+	const char *label[2];
>>>>>>>> > >>>>>>  	u32 fleds[2];
>>>>>>>> > >>>>>>  	u32 iout_torch[2];for_each_available_child_of_node
>>>>>>>> > >>>>>>  	u32 iout_flash[2];
>>>>>>>> > >>>>>>  	u32 trigger[2];
>>>>>>>> > >>>>>>  	u32 trigger_type[2];
>>>>>>>> > >>>>>>+	u32 flash_timeout[2];
>>>>>>>> > >>>>>>  	u32 num_leds;
>>>>>>>> > >>>>>>  	u32 boost_mode;
>>>>>>>> > >>>>>>-	u32 flash_timeout;
>>>>>>>> > >>>>>>  	u32 boost_vout;
>>>>>>>> > >>>>>>  	u32 low_vsys;
>>>>>>>> > >>>>>>+	struct device_node *sub_nodes[2];
>>>>>>> > >>>>>
>>>>>>> > >>>>>I haven't seen anyone do this before.  Why can't you use the provided
>>>>>>> > >>>>>OF functions to traverse through your tree?
>>>>>> > >>>>
>>>>>> > >>>>I use for_each_available_child_of_node when parsing DT node, but I
>>>>>> > >>>>need to cache the pointer to sub-node to be able to use it later
>>>>>> > >>>>when it needs to be passed to V4L2 sub-device which is then
>>>>>> > >>>>asynchronously matched by the phandle to sub-node.
>>>>>> > >>>>
>>>>>> > >>>>If it is not well seen to cache it in the platform data then
>>>>>> > >>>>I will find different way to accomplish this.
>>>>> > >>>
>>>>> > >>>I haven't seen the end-driver for this, but why can't you use that
>>>>> > >>>device's of_node pointer?
>>>> > >>
>>>> > >>Maybe it is indeed a good idea. I could pass the of_node pointer
>>>> > >>and the sub-led identifier to the V4L2 sub-device and there look
>>>> > >>for the sub-node containing relevant identifier. The downside
>>>> > >>would be only that for_each_available_child_of_node would
>>>> > >>have to be called twice - in the led driver and in the V4L2 sub-device.
>>>> > >>I think that we can live with it.
>>> > >
>>> > >Are the LED and V4L2 drivers children of this MFD?  If so, you can use
>>> > >the of_compatible attribute in struct mfd_cell to populate the each
>>> > >child's of_node dynamically i.e. the MFD core will do that for you.
>>> > >
>> > 
>> > V4L2 driver wraps LED driver. This way the LED device can be
>> > controlled with use of two interfaces - LED subsystem sysfs
>> > and V4L2 Flash. This is the aim of the whole patch set.
>> > 
>> > I've thought it over again and it seems that I will need to cache
>> > somewhere these sub_nodes pointers. They have to be easily accessible
>> > for the V4L2 sub-device as it can be asynchronously registered
>> > or unregistered within V4L2 media device. Sub-devices are matched
>> > basing on the sub-node phandle.
>
> Not quite getting this.  Can you explain this in another way please?

Only the LED controller driver is a child the MFD. The LED controller
can contain multiple outputs with a physical LED attached to it. AFAICS
this binding is modelling each such an output as a the LED's controller
node child node.

I'm not sure though why storing the device node pointers is required,
rather than traversing OF tree when needed.
I guess we only need the list of the node pointer to populate struct
v4l2_async_subdev array for v4l2_async_notifier_register() call ?


-- 
Regards,
Sylwester
