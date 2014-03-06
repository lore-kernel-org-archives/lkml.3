Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaCFPra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:47:30 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60193 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaCFPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:47:28 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fa-5318988ec5ad
Message-id: <5318988C.2030004@samsung.com>
Date: Thu, 06 Mar 2014 16:47:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
 <53170C00.20200@ti.com> <1394030554.8754.31.camel@paszta.hi.pengutronix.de>
 <20140306141657.GB21483@n2100.arm.linux.org.uk>
 <20140306121721.6186dafb@samsung.com>
In-reply-to: <20140306121721.6186dafb@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xy7p9MySCDWb/Y7SYf+Qcq8X7jfOY
	LA782cFocbbpDbtF58Ql7BaXd81hs+jZsJXV4vZlXouL6+Qt7t47wWLRuvcIu8X6+bfYHHg8
	Wpp72Dw+fIzzmN0xk9Vj06pONo871/awefT/NfDo27KK0eP4je1MHp83yQVwRnHZpKTmZJal
	FunbJXBlrPx6hLHglGzF/AUdLA2Mk8S7GDk5JARMJD58PcYIYYtJXLi3nq2LkYtDSGApo8Ta
	H6tYIZxPjBLNe3eAVfEKaEn8f/GBBcRmEVCVmHrzBZjNJmAo0Xu0D6xGVCBC4tXZiSwQ9YIS
	PybfYwEZJCLQzijR9ukWM4jDLPCaSeLxhNdAGQ4OYYEAiSV7GSG2vWOU2HjxB9gkTgEjibXf
	NjKB2MwCOhL7W6exQdjyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4
	NC9dLzk/dxMjJHq+7mBceszqEKMAB6MSD+8GP/FgIdbEsuLK3EOMEhzMSiK8stUSwUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoY9a6XfeUunfLJ40v4WclWtxefd3Qd8bS4pfjm7nXGoz9/VFvc
	1+qcHTXP+1JkSX3+pzvus58cNtGqNJr2blX47Y4Zu//Nfyvx5t+Gi8Z75j2b2n+Db0qg+/ul
	AX8vmMx9wRIg8DGOSSL+7cfpLn/ajsvcNlN+80vRY9LcykXHX3xkSbi3jLV6tYcSS3FGoqEW
	c1FxIgD08a+8fAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 16:17, Mauro Carvalho Chehab wrote:
> Em Thu, 06 Mar 2014 14:16:57 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:
> 
>> > On Wed, Mar 05, 2014 at 03:42:34PM +0100, Philipp Zabel wrote:
>>> > > Am Mittwoch, den 05.03.2014, 13:35 +0200 schrieb Tomi Valkeinen:
>>>> > > > Hi,
>>>> > > > 
>>>> > > > On 05/03/14 11:20, Philipp Zabel wrote:
>>>>> > > > > Hi,
>>>>> > > > > 
>>>>> > > > > this version of the OF graph helper move series further addresses a few of
>>>>> > > > > Tomi's and Sylwester's comments.
>>>>> > > > > 
>>>>> > > > > Changes since v5:
>>>>> > > > >  - Fixed spelling errors and a wrong device node name in the link section
>>>>> > > > >  - Added parentless previous endpoint's full name to warning
>>>>> > > > >  - Fixed documentation comment for of_graph_parse_endpoint
>>>>> > > > >  - Unrolled for-loop in of_graph_get_remote_port_parent
>>>>> > > > > 
>>>>> > > > > Philipp Zabel (8):
>>>>> > > > >   [media] of: move graph helpers from drivers/media/v4l2-core to
>>>>> > > > >     drivers/of
>>>>> > > > >   Documentation: of: Document graph bindings
>>>>> > > > >   of: Warn if of_graph_get_next_endpoint is called with the root node
>>>>> > > > >   of: Reduce indentation in of_graph_get_next_endpoint
>>>>> > > > >   [media] of: move common endpoint parsing to drivers/of
>>>>> > > > >   of: Implement simplified graph binding for single port devices
>>>>> > > > >   of: Document simplified graph binding for single port devices
>>>>> > > > >   of: Warn if of_graph_parse_endpoint is called with the root node
>>>> > > > 
>>>> > > > So, as I've pointed out, I don't agree with the API, as it's too limited
>>>> > > > and I can't use it, but as this series is (mostly) about moving the
>>>> > > > current API to a common place, it's fine for me.
>>>> > > > 
>>>> > > > Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>>> > > 
>>> > > Thanks. I'll be happy to help expanding the API to parse ports
>>> > > individually, once this gets accepted.
>>> > > 
>>> > > Mauro, Guennadi, are you fine with how this turned out? I'd like to get
>>> > > your acks again, for the changed location.
>
> From my side, there's nothing on such code that is V4L2 specific.
> Moving it to drivers/of makes sense on my eyes.
> 
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

I'm OK with patches 1...5, 8, so for these:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Regarding the simplified version of the binding, I thought we should
leave 'port' instead of 'endpoint' node. This could cover more hardware
configurations. Are there any users of this simplified binding queued
for v3.15 ? If not, perhaps we can postpone it and discuss it a bit more
(sorry, couldn't find time to comment on that earlier) ?

>> > I'll need those acks before I can even think about queuing up the
>> > imx-drm bits.
>> > 
>> > Another way to deal with this is if this gets pulled into the V4L tree
>> > from Philipp's git tree, I can also pull that in myself.  What mustn't
>> > happen is for these to be committed independently as patches.
>
> If everyone agrees, I actually prefer have this patch applied on my tree,
> in order to avoid some potential merge conflicts at the merge window,
> as we might have other drivers and changes there touching on those API
> calls (I'm aware of a series of patches from Sylwester with some DT
> stuff on it. Not sure if it would be affected by such changes or not).

Yes, it's going to conflict with my patch series. I thought it could be
put onto a stable a topic branch, e.g. at git://linuxtv.org/media_tree.git,
which could be then pulled into the media master branch and anywhere
else it is needed ?

--
Regards,
Sylwester
