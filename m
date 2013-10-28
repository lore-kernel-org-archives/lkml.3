Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3J1Wt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:49:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60171 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757752Ab3J1WtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:49:16 -0400
Date: Mon, 28 Oct 2013 22:49:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
Message-ID: <20131028224900.GB4763@kartoffel>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
 <20131027134607.E1782C4039D@trevor.secretlab.ca>
 <526EDB80.7080406@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <526EDB80.7080406@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 09:47:44PM +0000, Stephen Warren wrote:
> On 10/27/2013 07:46 AM, Grant Likely wrote:
> > On Tue, 15 Oct 2013 21:39:23 +0100, Grant Likely <grant.likely@linaro.org> wrote:
> >> The standard interrupts property in device tree can only handle
> >> interrupts coming from a single interrupt parent. If a device is wired
> >> to multiple interrupt controllers, then it needs to be attached to a
> >> node with an interrupt-map property to demux the interrupt specifiers
> >> which is confusing. It would be a lot easier if there was a form of the
> >> interrupts property that allows for a separate interrupt phandle for
> >> each interrupt specifier.
> >>
> >> This patch does exactly that by creating a new interrupts-extended
> >> property which reuses the phandle+arguments pattern used by GPIOs and
> >> other core bindings.
> >>
> >> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> >> Cc: Rob Herring <rob.herring@calxeda.com>
> > 
> > Alright, I want to merge this one. I've got an Ack from Tony, general
> > agreement from an in person converstaion from Ben (aside from wishing he
> > could think of a better property name), and various rumblings of
> > approval from anyone I talked to about it at ksummit. I'd like to have
> > something more that that to put into the commit text. Please take a look
> > and let me know if you agree/disagree with this binding.
> 
> The new binding makes sense to me. So, the binding,
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> A couple of minor perhaps bikesheddy comments below.
> 
> >> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> 
> >> +Nodes that describe devices which generate interrupts must contain an either an
> >> +"interrupts" property or an "interrupts-extended" property. These properties
> 
> "interrupts-ex" would be shorter, although I guess slightly harder to
> guess its purpose, unless you're familiar with "ex" in symbol names.

I'd prefer a more precise name. IMO "-extended" is preferable to "-ex".

> 
> ...
> >> +A device node may contain either "interrupts" or "interrupts-extended", but not
> >> +both. If both properties are present, then the operating system should log an
> >> +error
> 
> That sounds rather like prescribing SW behaviour, which I thought DT
> bindings shouldn't do?

I think recommending a behaviour relating to parsing is valid. Parsing notes in
bindings make it very easy to write an extensible binding. I think if we'd just
stated that having both properties was invalid you would not have a problem?

> 
> >> and use only the data in "interrupts".
> 
> ... so perhaps that's better phrased as:
> 
> A device node may contain either "interrupts" or "interrupts-extended",
> but not both. If both properties are present, the data in "interrupts"
> takes precedence.
> 

This sounds reasonable to me, but I'd definitely want the kernel to scream
(though I appreciate that's separate from the binding details).

Thanks,
Mark.
