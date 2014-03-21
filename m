Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290AbaCUKog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:44:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43842 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbaCUKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:44:33 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-8c-532c180f3e1b
Message-id: <532C1808.6090409@samsung.com>
Date: Fri, 21 Mar 2014 11:44:24 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
 <139468148.3QhLg3QYq1@avalon> <531F08A8.300@ti.com>
 <1883687.VdfitvQEN3@samsung.com> <avalon@samsung.com>
 <20140320172302.CD320C4067A@trevor.secretlab.ca>
In-reply-to: <20140320172302.CD320C4067A@trevor.secretlab.ca>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xq7r8EjrBBmfb+C3mHznHanHgzw5G
	i7NNb9gtOicuYbe4vGsOm0XPhq2sFrcv81pcXCdvcffeCRaLrfPOMVq07j3CbvH92zc2i7/b
	N7FYHH7Tzmqxfv4tNgd+j5bmHjaPnbPusnvM7pjJ6rFpVSebx51re9g8+v8aePRtWcXocfzG
	diaPz5vkAjijuGxSUnMyy1KL9O0SuDJ+3t7MUrBXtGLqwh1MDYyTBbsYOTgkBEwkPv2o6WLk
	BDLFJC7cW8/WxcjFISSwlFHi24KJ7BDOJ0aJjY/nMIJU8QpoSZzb3wRmswioSpx5upYVxGYT
	0JT4u/kmG4gtKhAhMXfiZjaIekGJH5PvsYDYIgI9jBL/d7iCDGUWOMwi0TZvGRNIQlggVWLt
	4dusENueM0rc3X8VbCqngK3E1Z5PYDazgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYw
	Mq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImtLzsYFx+zOsQowMGoxMNbwakdLMSaWFZc
	mXuIUYKDWUmEd+kvoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGrSYbqecmLBeuJX86p/z+2n7l
	FV1PdE4WST9Xm6vWc8rcZuPtTenh9xleW95tCmuq0wze+i5Trf+vrZbmZaY7i87kGM70uvZL
	qm3mGr3vUzWfHXTfV51tdDWUIfdka/bZlwI5Ry4/sd5nfbrPUj5ohp90zDTe3v7LhafyF3so
	vZc9v9u4XElOiaU4I9FQi7moOBEAqS1ZDYsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 06:23 PM, Grant Likely wrote:
> On Tue, 11 Mar 2014 14:16:37 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> On Tuesday 11 March 2014 14:59:20 Tomi Valkeinen wrote:
>>> So depending on the use case, the endpoints would point to opposite
>>> direction from the encoder's point of view.
>>>
>>> And if I gathered Grant's opinion correctly (correct me if I'm wrong),
>>> he thinks things should be explicit, i.e. the bindings for, say, an
>>> encoder should state that the encoder's output endpoint _must_ contain a
>>> remote-endpoint property, whereas the encoder's input endpoint _must
>>> not_ contain a remote-endpoint property.
>>
>> Actually my understand was that DT links would have the same direction as the 
>> data flow. There would be no ambiguity in that case as the direction of the 
>> data flow is known. What happens for bidirectional data flows still need to be 
>> discussed though. And if we want to use the of-graph bindings to describe 
>> graphs without a data flow, a decision will need to be taken there too.
> 
> On further thinking, I would say linkage direction should be in the
> direction that would be considered the dependency order... I'm going to
> soften my position though. I think the generic pattern should still
> recommend unidirection links in direction of device dependency, but

I am not sure what you mean by 'device dependency' but I am sure it will
not be difficult to present problematic cases, maybe circular
dependencies, two-way dependencies, etc.

The only problem of unidirectional links from programming point of view
is that destination port/interface should be exposed using some
framework and driver of source link should grab it using the same
framework, using port/endpoint node for identification. In case of
bi-directional links the same process should happen but DT do not
dictates who should expose and who grabs.

So from programming point of view it should be easy to handle
unidirectional links regardless of the direction. So I guess the best
is to use data flow direction as it seems to be the most natural.


> I'm okay with allowing the bidirection option if the helper functions
> are modified to validate the target endpoint. I think it needs to test
> for the following:
> - Make sure the endpoint either:
>   - does not have a backlink, or
>   - the backlink points back to the origin node
> - If the target is an endpoint node, then make sure the parent doesn't
>   have a link of any kind
> - If the target is a port node, make sure it doesn't have any endpoint
>   children nodes at all.

I think link validation can be done at dts compile time.

Regards
Andrzej

> 
> g.
> 
> 

