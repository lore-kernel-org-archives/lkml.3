Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaCKLMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:12:16 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:37259 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaCKLMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:12:13 -0400
X-AuditID: cbfec372-b7fa96d000006a7b-a8-531eef8b1be9
Date: Tue, 11 Mar 2014 08:12:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] Move device tree graph parsing helpers to drivers/of
Message-id: <20140311081203.0da93daf@samsung.com>
In-reply-to: <20140310143758.3734FC405FA@trevor.secretlab.ca>
References: <1394126000.3622.66.camel@paszta.hi.pengutronix.de>
 <20140307182330.75168C40AE3@trevor.secretlab.ca>
 <20140310102630.3cb1bcd7@samsung.com> <samsung.com@samsung.com>
 <20140310143758.3734FC405FA@trevor.secretlab.ca>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/hIN3u93LBBkefy1nMP3KO1eL9xnlM
	Fgf+7GC0aF68ns3ibNMbdovOiUvYLS7vmsNm0bNhK6vF7cu8FnfvnWCxaN17hN3i8Jt2Vov1
	82+xOfB6tDT3sHl8+BjnMbtjJqvHplWdbB53ru1h89g/dw27R/9fA4++LasYPY7f2M7k8XmT
	XABXFJdNSmpOZllqkb5dAlfGkmMtzAUNghVvbvxga2DcwNvFyMkhIWAiMW/zf1YIW0ziwr31
	bF2MXBxCAksYJSZMvcQM4XQzSezacp0ZpIpFQFViU+sFFhCbTcBI4lVjC1i3iICWxJM5n8G6
	mQU+M0s8urIMLCEs4CPRefwmO4jNK2Ao8eDKQ7BBnAK2Ei1HpjJCbHjOKPFx110miDucJF69
	nswE0SAo8WPyPbBtzEAbNm9rYoWwtSWevLvAOoFRYBaSsllIymYhKVvAyLyKUbS0OLmgOCk9
	11CvODG3uDQvXS85P3cTIySminYwPttgdYhRgINRiYd3hb9csBBrYllxZe4hRgkOZiUR3ov3
	gEK8KYmVValF+fFFpTmpxYcYmTg4pRoYjfx//925ysPh18y1v6xZNkge/LRccsLl0A+Hsnik
	ClkWHmnZHLbxHW9W3Y7IZYn1RjK5L8rmBXyJNj2b9Ti5e3rGwcOl222tvHOV3qtaLYr9YqEj
	KLzaXTB8y2ST/DNHXocyuusZer+/EBrqGPuE5wvnp4J5NilF4vlvTkY7Gn/m2r3ptMNXJZbi
	jERDLeai4kQA4alsZIcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 10 Mar 2014 14:37:58 +0000
Grant Likely <grant.likely@linaro.org> escreveu:

> On Mon, 10 Mar 2014 10:26:30 -0300, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> > Em Fri, 07 Mar 2014 18:23:30 +0000
> > Grant Likely <grant.likely@linaro.org> escreveu:
> > 
> > > On Thu, 06 Mar 2014 18:13:20 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > > > Hi Mauro, Russell,
> > > > 
> > > > I have temporarily removed the simplified bindings at Sylwester's
> > > > request and updated the branch with the acks. The following changes
> > > > since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:
> > > > 
> > > >   Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)
> > > > 
> > > > are available in the git repository at:
> > > > 
> > > >   git://git.pengutronix.de/git/pza/linux.git topic/of-graph
> > > > 
> > > > for you to fetch changes up to d484700a36952c6675aa47dec4d7a536929aa922:
> > > > 
> > > >   of: Warn if of_graph_parse_endpoint is called with the root node (2014-03-06 17:41:54 +0100)
> > > 
> > > Nak. I made comments that haven't been resolved yet. I've replied with
> > > more detail tonight. The big issues are how drivers handle the optional
> > > 'ports' node and I do not agree to the double-linkage in the binding
> > > description.
> > 
> > If I understood well, you're requesting to revert all those six patches
> > that were imported via git pull from my tree (and from Greg and Russell),
> > right?
> > 
> > E. g. reverting those changesets:
> > 	d484700a3695 f2a575f67695 4329b93b283c 6ff60d397b17 4d56ed5a009b fd9fdb78a9bf
> > 
> > as it seems that there's no easy way to revert a git pull.
> 
> All trees containing the branch would need to be reverted.
> 
> > I suspect that this will likely cause some harm when merging from our
> > trees upstream.
> 
> It means any tree containing that branch *must* be rewound. 

Grr...

Done. I really preferred not doing that.

>From my side, it became too late to apply those OF changes on my tree 
for 3.15, as I will not prevent other patches to be applied on my tree
due to that.

Mauro
