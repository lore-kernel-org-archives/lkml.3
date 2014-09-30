Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaI3T4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:56:46 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8648 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbaI3T4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:56:44 -0400
Date: Tue, 30 Sep 2014 12:56:53 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
Message-ID: <20140930195652.GT28481@sonymobile.com>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
 <5429DA95.80505@codeaurora.org>
 <20140930050203.GG28481@sonymobile.com>
 <542AF5FE.1000006@codeaurora.org>
 <20140930190023.GS28481@sonymobile.com>
 <542B00C1.3010702@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <542B00C1.3010702@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Sep 12:13 PDT 2014, Stephen Boyd wrote:

> On 09/30/14 12:00, Bjorn Andersson wrote:
> >
> > Hmm, seems I got that wrong, sorry about that.
> >
> > But do you mean "all wrong" as in that I use the wrong bit or to some greater
> > extent? Currently all following requests should timeout, but maybe we should
> > have a faster fail-path when we've hit this point?
> 
> Yes. We just ack the interrupt and go on happy to keep allowing clients
> to request things. I'd rather see us blow up or start failing requests,
> or maybe both.
> 

Okay, I naively figured that the RPM would be dead after this happened and from
this point we would start getting timeouts. Let's ack the right bit and fail
early after the RPM have rejected things.

> >
> > From a practical pov I guess that once the rpm starts returning errors on
> > updates to regulators, root clocks and bus scaling then most of the system is
> > becoming useless.
> 
> Right. Rebooting will be required fairly soon.
> 

Yes, but we want something else to trigger that right?

Regards,
Bjorn
