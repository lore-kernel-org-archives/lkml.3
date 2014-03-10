Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaCJI6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:58:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18807 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaCJI62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:58:28 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-bc-531d7eb2519c
Message-id: <531D7E9F.3090708@samsung.com>
Date: Mon, 10 Mar 2014 09:58:07 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
 <20140307171804.EF245C40A32@trevor.secretlab.ca>
 <CA+gwMcfgKre8S4KHPvTVuAuz672aehGrN1UfFpwKAueTAcrMZQ@mail.gmail.com>
 <1536567.OYzyi25bjL@avalon>
In-reply-to: <1536567.OYzyi25bjL@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xK7qb6mSDDfbPFLWYf+Qcq8X7jfOY
	LA782cFocbbpDbtF58Ql7BaXd81hs+jZsJXV4vZlXouL6+Qt7t47wWKxdd45RovWvUfYLQ6/
	aWe1WD//FpsDn0dLcw+bx85Zd9k9PnyM85jdMZPVY9OqTjaPO9f2sHn0/zXw6NuyitHj+I3t
	TB6fN8kFcEVx2aSk5mSWpRbp2yVwZbRu28dU8E+7on3RVKYGxt1yXYycHBICJhIbpi9lhLDF
	JC7cW88GYgsJLGWUWHfSsIuRC8j+xCix/v97sCJeAS2J/k/LwGwWAVWJ2y1N7CA2m4CmxN/N
	N8GaRQUiJOZO3MwGUS8o8WPyPRYQW0QgWWLfo+dsIEOZBXaySPQtXwc2SFggXaLz1x9GiG33
	GCUe/b7EDJLgFNCQeNcMsYFZQEdif+s0NghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqaW
	JhcUJ6XnGuoVJ+YWl+al6yXn525ihETWlx2Mi49ZHWIU4GBU4uE98FYmWIg1say4MvcQowQH
	s5IIb0acbLAQb0piZVVqUX58UWlOavEhRiYOTqkGxoK1uyL7n5j9vX24znizpAR30u6UFXvj
	AtK1A9o2Hvpbtmi9546ZjKxHzCunKOtXJc6otmxy+1185QhrurzI/Sh79Xv+7yZmLDrE1GPa
	0Cc3x/aJ2ndOVYaLmySf1pk6Ota1Bh9/pXDlYH7T8fzjSy/rKsyKfFjSlffQ7dfcFo2PvvHG
	sks5lFiKMxINtZiLihMBxPaxGooCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/08/2014 04:54 PM, Laurent Pinchart wrote:
> Hi Philipp,
> 
> On Saturday 08 March 2014 13:07:23 Philipp Zabel wrote:
>> On Fri, Mar 7, 2014 at 6:18 PM, Grant Likely wrote:
>>> On Wed, 26 Feb 2014 16:24:57 +0100, Philipp Zabel wrote:
>>>> The 'ports' node is optional. It is only needed if the parent node has
>>>> its own #address-cells and #size-cells properties. If the ports are
>>>> direct children of the device node, there might be other nodes than
>>>>
>>>> ports:
>>>>       device {
>>>>               #address-cells = <1>;
>>>>               #size-cells = <0>;
>>>>               
>>>>               port@0 {
>>>>                       endpoint { ... };
>>>>               };
>>>>               port@1 {
>>>>                       endpoint { ... };
>>>>               };
>>>>               
>>>>               some-other-child { ... };
>>>>       };
>>>>       
>>>>       device {
>>>>               #address-cells = <x>;
>>>>               #size-cells = <y>;
>>>>               
>>>>               ports {
>>>>                       #address-cells = <1>;
>>>>                       #size-cells = <0>;
>>>>                       
>>>>                       port@0 {
>>>>                               endpoint { ... };
>>>>                       };
>>>>                       port@1 {
>>>>                               endpoint { ... };
>>>>                       };
>>>>               };
>>>>               
>>>>               some-other-child { ... };
>>>>       };
>>>
>>> From a pattern perspective I have no problem with that.... From an
>>> individual driver binding perspective that is just dumb! It's fine for
>>> the ports node to be optional, but an individual driver using the
>>> binding should be explicit about which it will accept. Please use either
>>> a flag or a separate wrapper so that the driver can select the
>>> behaviour.
>>
>> If the generic binding exists in both forms, most drivers should be
>> able to cope with both. Maybe it should be mentioned in the bindings
>> that the short form without ports node should be used where possible
>> (i.e. for devices that don't already have #address,size-cells != 1,0).
>>
>> Having a separate wrapper to enforce the ports node for devices that
>> need it might be useful.
>>
>>>> The helper should find the two endpoints in both cases.
>>>>
>>>> Tomi suggests an even more compact form for devices with just one port:
>>>>       device {
>>>>               endpoint { ... };
>>>>               
>>>>               some-other-child { ... };
>>>>       };
>>>
>>> That's fine. In that case the driver would specifically require the
>>> endpoint to be that one node.... although the above looks a little weird
>>> to me. I would recommend that if there are other non-port child nodes
>>> then the ports should still be encapsulated by a ports node.  The device
>>> binding should not be ambiguous about which nodes are ports.
>>
>> Sylwester suggested as an alternative, if I understood correctly, to
>> drop the endpoint node and instead keep the port:
>>
>>     device-a {
>>         implicit_output_ep: port {
>>             remote-endpoint = <&explicit_input_ep>;
>>         };
>>     };
>>
>>     device-b {
>>         port {
>>             explicit_input_ep: endpoint {
>>                 remote-endpoint = <&implicit_output_ep>;
>>             };
>>         };
>>     };
>>
>> This would have the advantage to reduce verbosity for devices with multiple
>> ports that are only connected via one endport each, and you'd always have
>> the connected ports in the device tree as 'port' nodes.
> 
> I like that idea. I would prefer making the 'port' nodes mandatory and the 
> 'ports' and 'endpoint' nodes optional. Leaving the 'port' node out slightly 
> decreases readability in my opinion, but making the 'endpoint' node optional 
> increases it. That's just my point of view though.
> 

I want to propose another solution to simplify bindings, in fact I have
few ideas to consider:

1. Use named ports instead of address-cells/regs. Ie instead of
port@number schema, use port-function. This will allow to avoid ports
node and #address-cells, #size-cells, reg properties.
Additionally it should increase readability of the bindings.

device {
	port-dsi {
		endpoint { ... };
	};
	port-rgb {
		endpoint { ... };
	};
};

It is little bit like with gpios vs reset-gpios properties.
Another advantage I see we do not need do mappings of port numbers
to functions between dts, drivers and documentation.

2. Similar approach can be taken to endpoint nodes, in fact
as endpoints are children of port node and as I understand port node
have no other children we can use any name instead of endpoint@number,
of course some convention can be helpful.

device {
	port-dsi {
		ep-soc1 { ... };
		ep-soc2 { ... };
	};
	port-rgb {
		ep-panel { ... };
	};
};

I would like to add that those ideas would work nicely with Sylwester's
proposition of skipping endpoints nodes in case there is only one
endpoint - the most common cases are devices with one or two ports, each
port having only one remote endpoint.
The complete graph for DSI/LVDS bridge I work recently will look like:

dsim {
	dsim_ep: port-dsi {
		remote-endpoint = <&bridge_dsi_ep>;
	};
};

bridge {
	bridge_dsi_ep: port-dsi {
		remote-endpoint = <&dsim_ep>;
	};
	bridge_lvds_ep: port-lvds {
		remote-endpoint = <&panel_ep>;
	};
};

panel {
	port-lvds {
		remote-endpoint <&bridge_lvds_ep>;
	};
};

Regards
Andrzej

