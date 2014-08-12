Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaHLQBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:01:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22786 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaHLQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:01:03 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-81-53ea3a3be218
Message-id: <53EA3A3A.7000600@samsung.com>
Date: Tue, 12 Aug 2014 18:00:58 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: Dual-channel DSI
References: <20140805153923.GA3072@ulmo.nvidia.com>
 <53E3227B.1010000@samsung.com> <20140807072530.GE17340@ulmo>
 <53E33B48.1080401@samsung.com> <20140807085424.GC13315@ulmo.nvidia.com>
 <53E47B99.3040105@samsung.com> <20140808101447.GF15852@ulmo>
In-reply-to: <20140808101447.GF15852@ulmo>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xy7rWVq+CDVZt1rM48P4gi8X8I+dY
	La58fc9m0f9mIavFuVcrGS06Jy5ht7i8aw6bxdLrF5ksJkxfy2LRuvcIu8XPXfNYLNbPv8Vm
	sXfnZEYHXo8189Ywelzu62Xy2DnrLrvHyuVf2Dxmd8xk9di0qpPN4373cSaPvi2rGD2O39jO
	5PF5k1wAVxSXTUpqTmZZapG+XQJXxucvQQUz4yrePpBtYJzp3cXIwSEhYCJxsLWii5ETyBST
	uHBvPVsXIxeHkMBSRon2e/vZIZxPjBL9ey6zg1TxCmhJzF/UxgRiswioSvxtbWMBsdkENCX+
	br7JBmKLCoRJPPt1kAmiXlDix+R7YDUiAroS/0+/YQEZyixwhlni94cjzCAJYQFZiQ3fl4AV
	CQn8ZpR4e1gOxOYEWraj9zwTyKXMAnoS9y9qgYSZBeQlNq95yzyBUWAWkhWzEKpmIalawMi8
	ilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkmr7sYFx8zOoQowAHoxIPr8Hpu8FCrIllxZW5
	hxglOJiVRHgX670KFuJNSaysSi3Kjy8qzUktPsTIxMEp1cC4qjyCjW+yr0ntW+nlISvX5ryQ
	/Nm0j9vpIn9AbK26yh7zI2Hv5y9Iuw807tmNKQe7pmXu7bV/ekX9rfPOSx7/EuYwXl8Rtv9I
	08+bLIetZnPyBF9o3Pdzz0HGE5HyDIvKuQxnb7G+XZJ4o05e6/6KxOSgDtHdP1USX8YzSGfv
	sFNZfOP+HRUlluKMREMt5qLiRACuF6r2hAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added DT maintainers as we have here quite fundamental DT question:

How shall we model hardware connected to multiple buses, in DT?

Here we have panel connected to two MIPI-DSI buses.

Below is the summary of our propositions, followed by lengthly detailed
discussion,
including proposed bindings.

Current propositions (ordered according to my preferences):
1. Subnode of the first DSI master with phandle to 2nd DSI master.
2. Separate node with phandles to both DSI masters.
3. Two different subnodes of both DSI masters with the same compatible
string,
and phandle in one node to another one.
4. Two different subnodes of both DSI masters with the same compatible
string
and separate node with another compatible string with phandles to both
DSI subnodes.

Notes:
- in the first two cases I guess phandles should be accompanied with bus
addresses,
- here we have two DSI buses but the problem will be similar with other
non-discoverable buses,
- case of 3 and 4 are original Thierry propositions, if they are
preferred I would consider to
  use different compatible strings for DSI subnodes as they describe
different HW interfaces.

My additional comments below.

On 08/08/2014 12:14 PM, Thierry Reding wrote:
> On Fri, Aug 08, 2014 at 09:26:17AM +0200, Andrzej Hajda wrote:
>> On 08/07/2014 10:54 AM, Thierry Reding wrote:
>>> On Thu, Aug 07, 2014 at 10:39:36AM +0200, Andrzej Hajda wrote:
>>>> On 08/07/2014 09:25 AM, Thierry Reding wrote:
>>>>> On Thu, Aug 07, 2014 at 08:53:47AM +0200, Andrzej Hajda wrote:
>>>>>> Hi Thierry,
>>>>>>
>>>>>> Nice case.
>>>>>>
>>>>>> On 08/05/2014 05:39 PM, Thierry Reding wrote:
>>>>>>> Hi everyone,
>>>>>>>
>>>>>>> I've been working on adding support for a panel that uses what's
>>>>>>> commonly known as dual-channel DSI. Sometimes this is referred to as
>>>>>>> ganged-mode as well.
>>>>>>>
>>>>>>> What is it, you ask? It's essentially a hack to work around the band-
>>>>>>> width restrictions of DSI, albeit one that's been commonly implemented
>>>>>>> by several SoC vendors.
>>>>>>>
>>>>>>> This typically works by equipping a peripheral with two DSI interfaces,
>>>>>>> each of which driving one half of the screen (symmetric left-right mode)
>>>>>>> or every other line (symmetric odd-even mode). Apparently there can be
>>>>>>> asymmetric modes in addition to those two, but they seem to be the
>>>>>>> common ones. Often both of the DSI interfaces need to be configured
>>>>>>> using DCS commands and vendor specific registers.
>>>>>>>
>>>>>>> A single display controller is typically used video data transmission.
>>>>>>> This is necessary to provide synchronization and avoid tearing and all
>>>>>>> kinds of other ugliness. For this to work both DSI controllers need to
>>>>>>> be made aware of which chunk of the video data stream is addressing
>>>>>>> them.
>>>>>>>
>>>>>>> From a software perspective, this poses two problems:
>>>>>>>
>>>>>>> 1) A dual-channel device is composed of two DSI peripheral devices which
>>>>>>>    cannot be programmed independently of each other. A typical example
>>>>>>>    is that the frame memory extents need to be configured differently
>>>>>>>    for each of the devices (using the DCS set_column_address and
>>>>>>>    set_page_address commands). Therefore each device must know of the
>>>>>>>    other, or there must be a driver that binds against a dummy device
>>>>>>>    that pulls in the two real devices.
>>>>>> I am not sure if I understand correctly, but I see it rather as one
>>>>>> device with two dsi-slave interfaces. Probably panel driver can
>>>>>> create dsi dummy device to program some registers
>>>>>> via second dsi interface but the panel will be attached to one control bus.
>>>>>> It seems to be very similar to mfd/i2c devices with two or more i2c
>>>>>> addresses.
>>>>> They are in fact attached to two different control busses. The DSI
>>>>> controllers that talk to each are separate. On Tegra they are the same
>>>>> type of IP block, but still two separate instances (with their own
>>>>> clock, reset, etc. inputs).
>>>>>
>>>>> So the panel driver can't create a dummy device to talk to the second
>>>>> DSI interface because the second DSI interface uses a different DSI
>>>>> host.
>>>> Why different DSI host does not allow that? The only thing panel needs
>>>> is the reference to another DSI host and this can be provided via
>>>> DT direct phandle or video interface.
>>> I'm sure one could find ways to make it work. That doesn't mean it's a
>>> good idea, though. The second peripheral is physically there on the
>>> second DSI host controller's bus, so it the device should be in device
>>> tree because so that the device tree matches reality.
>> The question is what is the reality? Do we have two separate dsi
>> devices? In such case
>> both devices should appear in DT.
>> If we have single device attached to two different DSI hosts I suppose
>> device should appear
>> only in one location in DT with link to another DSI host.
> Doesn't the fact that both devices are connected to different DSI hosts
> make them separate device? While it's physically one device only (there
> is one panel), device tree defines devices in terms of the control bus
> that they are connected to. Since in this case both subdevices are
> controlled by different DSI hosts that makes them separate devices.
>
>>>>>>> 2) On the DSI host side, each of the controller instances needs to know
>>>>>>>    the intimate details of the other controller (or alternatively, one
>>>>>>>    controller needs to be a "master" and the other a "slave").
>>>>>> The question is if they need to communicate each other, or they have
>>>>>> to have similar configurations applied?
>>>>> On Tegra at least the configuration needs to be almost the same. There
>>>>> are two registers that may need to be programmed differently. But they
>>>>> don't have to communicate with each other. Essentially the two registers
>>>>> that require different programming define which parts of the display
>>>>> controller's data stream they need to capture and turn into DSI packets.
>>>>>
>>>>> Theoretically it would be possible to make this work with two completely
>>>>> different DSI controllers, but in practice I'd expect that to never
>>>>> happen. So I'm not sure we need to consider the case where the register
>>>>> layout is different between the two DSI host controllers.
>>>> So maybe the configuration could be provided by the panel.
>>> What configuration? I suppose one idea would be for the panel driver to
>>> set the type of dual-channel mode that it's using. Panels can typically
>>> be configured to do symmetric left-right or symmetric odd-even. I think
>>> technically it's possible to have asymmetric modes, too, but to be
>>> honest I don't want to think about those yet.
>>>
>>> So I think it's reasonable for the DSI device to provide information as
>>> to what mode it's using. Perhaps that could be done as part of the slave
>>> setup.
>>>
>>>>> I've come up with another alternative that works:
>>>>>
>>>>> 	dsi@54300000 {
>>>>> 		panel: panel@0 {
>>>>> 			compatible = "sharp,lq101r1sx01";
>>>>> 			reg = <0>;
>>>>> 		};
>>>>> 	};
>>>>>
>>>>> 	dsi@54400000 {
>>>>> 		panel@0 {
>>>>> 			compatible = "sharp,lq101r1sx01";
>>>>> 			reg = <0>;
>>>>>
>>>>> 			master = <&panel>;
>>>>> 		};
>>>>> 	};
>>>> But here you have again two compatibles and two devices in DT representing
>>>> one HW device.
>>> Because that's what they really are. There are two different devices,
>>> it's just that they happen to be driving two separate halves of the same
>>> panel.
>> Compatible string "sharp,lq101r1sx01" clearly indicates that there are
>> two panels of type LQ101R1SX01.
>> If you really want to split this panel as two separate devices maybe you
>> should probably use separate
>> compatibles to make it more clear, sth like: "sharp,lq101r1sx01_link1",
>> "sharp,lq101r1sx01_link2".
>> Anyway it looks odd to me :)
> As best as I can tell both subdevices are actually the same.

The first represents LINK1 according to spec, more specifically
pins 2-16 of the chip, the 2nd represents LINK2 (pins 17-31) :)
The first is probably only for the left part, the 2nd for the right part
of the panel,
or respectively even/odd lines.

What about TE pin? It is single for the whole panel. Where do you want
to place it?
The same question regarding power pins.

>  Although it
> seems like commands written to the primary channel have an effect on the
> device as a whole. For example if you send a DCS exit_sleep_mode command
> to the primary channel then both devices will wake up. Similarly sending
> the DCS set_display_on command will turn on the display on both halves,
> not just the one. I haven't checked yet whether the same is true when
> the commands are sent to the secondary.
>
> One other solution I had thought about looked something like this:
>
> 	dsi@54300000 {
> 		left: panel@0 {
> 			compatible = "sharp,lq101r1sx01-link";
> 			reg = <0>;
> 			...
> 		};
> 	};
>
> 	dsi@54400000 {
> 		right: panel@0 {
> 			compatible = "sharp,lq101r1sx01-link";
> 			reg = <0>;
> 			...
> 		};
> 	};
>
> 	panel: panel {
> 		compatible = "sharp,lq101r1sx01";
> 		links = <&left &right>;
> 	};
>
> The downside of that being that &panel becomes a non-DSI device and we
> loose meta information such as the number of lanes etc.
>
> Perhaps this could be solved by using a device_type = "dsi" property and
> thereby cause the driver core to instantiate a DSI device rather than a
> platform device. Or perhaps even device_type = "dual-dsi" so that it
> could directly hook up both channels.
>
> But that's not all that different from the minimal proposal above, and I
> don't know if it's worth the trouble. Anyway, it would be good to hear
> thoughts on this from the device tree maintainers.
>
>>>> I am not sure if it is better. If you do not like video
>>>> interfaces
>>>> maybe better would be sth like this:
>>>>
>>>> 	dsi@54300000 {
>>>> 		panel: panel@0 {
>>>> 			compatible = "sharp,lq101r1sx01";
>>>> 			reg = <0>;
>>>> 			secondary_dsi = <&dsiB>;
>>>>  		};
>>>> 	};
>>>>
>>>> 	dsiB: dsi@54400000 {
>>>> 	};
>>> That's pretty much the same thing that I proposed, except that it
>>> reverses the link between the two.
>> For me it is fundamentally different - in your proposition you have two
>> different panels, in my you have only one, attached to one dsi with
>> phandle to 2nd dsi.
> Looking at the example again I don't see how it could work. The phandle
> references the second DSI host, but we need a reference to the second
> DSI peripheral. We can't just assume that it's on the same virtual
> channel as the first.

Phandle can be accompanied by bus address:
    secondary_dsi = <&dsiB 0>;

The rest of configuration if necessary can be specified by other properties.
This way the driver can create 2nd device using DSI equivalent of
i2c_new_device.
And we do not have problem where to put TE gpio, regulators, maybe PWM
phandle.

Regards
Andrzej

>
>>> In fact I tried something similar to
>>> that before, but it has a couple of problems: if the secondary device
>>> does not have a compatible string (that's probably not valid in device
>>> tree to begin with) then there's no way for the device to report what
>>> format it expects or what number of lanes it uses. But those are
>>> parameters that are needed to set up the DSI (and display controllers).
>> I2C has:
>> struct i2c_client *
>> i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
>>
>> DSI could have something similar, this way you could pass everything you
>> need.
> We don't need any of that if both devices have a proper compatible
> string, which they should have anyway, since then the driver can fill in
> those values as appropriate.
>
> Thierry

