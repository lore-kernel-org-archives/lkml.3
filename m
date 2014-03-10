Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaCJLgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:36:12 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44897 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaCJLgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:36:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 2/8] Documentation: of: Document graph bindings
Date: Mon, 10 Mar 2014 12:37:42 +0100
Message-ID: <2406124.RniJY1n1Xd@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394443690.7380.10.camel@paszta.hi.pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de> <20140307182717.67596C40B43@trevor.secretlab.ca> <1394443690.7380.10.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Monday 10 March 2014 10:28:10 Philipp Zabel wrote:
> Hi Grant,
> 
> Am Freitag, den 07.03.2014, 18:27 +0000 schrieb Grant Likely:
> > On Wed,  5 Mar 2014 10:20:36 +0100, Philipp Zabel wrote:
> > > The device tree graph bindings as used by V4L2 and documented in
> > > Documentation/device-tree/bindings/media/video-interfaces.txt contain
> > > generic parts that are not media specific but could be useful for any
> > > subsystem with data flow between multiple devices. This document
> > > describes the generic bindings.
> > > 
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > See my comments on the previous version. My concerns are the handling of
> > the optional 'ports' node and the usage of reverse links.
> 
> would this change address your concern about the reverse links? As the
> preexisting video-interfaces.txt bindings mandate the reverse links, I
> worry about introducing a second, subtly different binding. It should be
> noted somewhere in video-interfaces.txt that the reverse links are
> deprecated for the but still supported by the code for backwards
> compatibility.

I'm very much against removing the reverse links. Without them the graph will 
become much more complex to parse. You can try to convince me, but for now I'm 
afraid it's a NACK.

> diff --git a/Documentation/devicetree/bindings/graph.txt
> b/Documentation/devicetree/bindings/graph.txt index 1a69c07..eb6cae5 100644
> --- a/Documentation/devicetree/bindings/graph.txt
> +++ b/Documentation/devicetree/bindings/graph.txt
> @@ -87,12 +87,13 @@ device {
>  Links between endpoints
>  -----------------------
> 
> -Each endpoint should contain a 'remote-endpoint' phandle property that
> points -to the corresponding endpoint in the port of the remote device. In
> turn, the -remote endpoint should contain a 'remote-endpoint' property. If
> it has one, -it must not point to another than the local endpoint. Two
> endpoints with their -'remote-endpoint' phandles pointing at each other
> form a link between the -containing ports.
> +Two endpoint nodes form a link between the two ports they are contained in
> +if one contains a 'remote-endpoint' phandle property, pointing to the other
> +endpoint. The endpoint pointed to should not contain a 'remote-endpoint'
> +property itself. Which direction the phandle should point in depends on
> the +device type. In general, links should be pointing outwards from
> central +devices that provide DMA memory interfaces, such as display
> controller, +video capture interface, or serial digital audio interface
> cores.
> 
>  device-1 {
>          port {
> @@ -104,8 +105,8 @@ device-1 {
> 
>  device-2 {
>          port {
> -                device_2_input: endpoint {
> -                        remote-endpoint = <&device_1_output>;
> +                device_2_input: endpoint { };
> +                       /* no remote-endpoint, this endpoint is pointed at
> */ };
>          };
>  };

-- 
Regards,

Laurent Pinchart

