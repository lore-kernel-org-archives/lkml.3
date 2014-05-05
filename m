Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaEEHis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:38:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43355 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaEEHip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:38:45 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-b0-53674004fb14
Message-id: <53674002.1030507@samsung.com>
Date: Mon, 05 May 2014 09:38:42 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrzej Hajda <andrzej.hajda@wp.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stansislawski <t.stanislaws@samsung.com>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 0/4] drivers/base: Generic framework for tracking
 internal interfaces
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
 <20140430154914.GA898@kroah.com> <53616E31.3050404@wp.pl>
 <20140430222839.GE26756@n2100.arm.linux.org.uk> <5361F1F3.7070005@wp.pl>
 <20140501091102.GF26756@n2100.arm.linux.org.uk>
In-reply-to: <20140501091102.GF26756@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e/4VV0Wh/Rgg/evtS16z51kstg1PcDi
	76Rj7BZXvr5ns2hevJ7NYtL9CSwWZ5vesFt0TlzCbrHp8TVWi8u75rBZ9GzYymox4/w+Jovb
	l3kt1h65y26xfsZrFot57S9ZLX7umsfiIOjR0tzD5vH71yRGj52z7rJ7zO6Yyeqx/dsDVo/9
	c9ewe9zvPs7ksXlJvUffllWMHp83yXkc7+tiDuCO4rJJSc3JLEst0rdL4Mr49Ju14JNExf1r
	H5gaGL8KdzFyckgImEhMXzWVGcIWk7hwbz1bFyMXh5DAUkaJi/tfsIEkhAQ+MUq0foroYuTg
	4BXQkph3nRskzCKgKvFq5V+wXjYBTYm/m2+ClYsKREjcazzMCmLzCghK/Jh8jwXEFhGIkTjd
	s5QJZD6zwFZWiQPbe8ASwgLxEm3zJrBCLP7DKPH04yxGkASngI3EjD3nwWxmAR2J/a3T2CBs
	eYnNa94yT2AUmIVkySwkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJ/X3cw
	Lj1mdYhRgINRiYfXwzslWIg1say4MvcQowQHs5II7yzG9GAh3pTEyqrUovz4otKc1OJDjEwc
	nFINjIX2vRJazduvL71rOeHmzH65qEmqRzhcTM64pXb99p/fz+l6VqpzM29gXuuqQOaSoFSF
	dawGUrN3Z6byVdnkZCk1/p72UvStHeuuaXsXd06KXsbSO5VH4aPvfz3D2j+PJL8xuvwtuMMk
	LmkdsyY/TvDTz/A9cWnMf2eYZIq9mrg2weF07kYPJZbijERDLeai4kQAwj3WUJ0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 11:11 AM, Russell King - ARM Linux wrote:
> On Thu, May 01, 2014 at 09:04:19AM +0200, Andrzej Hajda wrote:
>> 2. You replace calls of component_add and component_del with calls
>> to interface_tracker_ifup(dev, INTERFACE_TRACKER_TYPE_COMPONENT,  
>> &specific_component_ops),
>> or interface_tracker_ifdown.
>> Thats all for components.
> How does the master get to decide which components are for it?

This is not a part of the framework. The master can construct
the list of its components anyhow. Some examples:
1. List of device tree video interface port nodes pointed by
master's remote-endpoint phandles.
2. List of device nodes pointed by supernode phandles.
3. Nodes pointed by other phandles in master's node.
4. Devices compatible with the list of drivers.

This is for create list of objects. As interface type it should
use the types of interface it expects at given nodes and is able to handle.

Small issue:
If the master creates list of devices and for particular interface
type expects DT node as the object, translation is easy: dev->of_node.
But if the situation is reverse kernel does not provide generic helper
for translating of_node to device, however kernel have everything to
provide such function if necessary.
Other solution is to use only DT nodes for object identification,
it will narrow the framework usage to DT architectures, but seems to be
more flexible anyway - we can have more than one interface of given type per
device, we can distinguish them by port node.

>   As
> I see it, all masters see all components of a particular "type".
> What if you have a system with two masters each of which are bound
> to a set of unique components but some of the components are of a
> the same type?

The master receives notifications only about interfaces he has
registered callback for. For example:
interface_tracker_register(node, INTERFACE_TRACKER_TYPE_DRM_PANEL, cb);

means that 'cb' callback will be called only if panel identifed by node
is up or down.
If the driver expect that at the 'node' there could be also component it
can also
listen for components:
interface_tracker_register(node, INTERFACE_TRACKER_TYPE_COMPONENT, cb);

Now 'cb' will be called if component or panel appears/disappears at node
'node'.

so callback function can look like:

void cb_func(struct interface_tracker_block *itb, const void *object,
unsigned long type, bool on,
                      void *data)
{
    struct priv_struct *priv = container_of(itb, struct priv_struct, itb);
    switch(type) {
    case INTERFACE_TRACKER_TYPE_DRM_PANEL:
        handle_drm_panel(priv, data, on);
        break;
    case INTERFACE_TRACKER_TYPE_DRM_COMPONENT:
        handle_drm_component(priv, data, object, on);
        break;
    }
}

where handlers can look like:

void handle_drm_panel(struct priv_struct *priv, struct drm_panel *panel,
bool on);
void handle_drm_component(struct priv_struct *priv, struct component_ops
*ops, struct device *dev, bool on);

>
> How does the master know what "type" to use?
>

It should use type which it expects at the given node.

Regards
Andrzej

