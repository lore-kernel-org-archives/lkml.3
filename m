Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaC2AcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:32:08 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:43979 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaC2AcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:32:06 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 1/5] of: Add support for ePAPR "stdout-path" property
To: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@linaro.org>
In-Reply-To: <CAL_Jsq+xTeocLtS9GFWLCkoV+USACma+w0=O_ysekvTGhYVhZg@mail.gmail.com>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org> < 1396022885-6102-2-git-send-email-grant.likely@linaro.org> <1396042396.11529 .27.camel@pasglop> <CAL_Jsq+xTeocLtS9GFWLCkoV+USACma+w0=O_ysekvTGhYVhZg@ mail.gmail.com>
Date: Fri, 28 Mar 2014 17:32:01 -0700
Message-Id: <20140329003201.EA13EC434EC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014 16:56:28 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Mar 28, 2014 at 4:33 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Fri, 2014-03-28 at 09:08 -0700, Grant Likely wrote:
> >> ePAPR 1.1 defines the "stdout-path" property for specifying the console
> >> device, but Linux currently only handles the older "linux,stdout-path"
> >> property. This patch adds parsing for the new property name.
> >
> > Generally a good idea I think, but of course I need time to review and
> > test ... :-)
> >
> > One thing that's been annoying me lately with the existing code which
> > you don't address is ... in a few cases my consoles are usable *VERY*
> > early. For example PAPR hvc and OPAL hvc can be used before we even turn
> > the MMU on on powerpc (and thus before we unflatten the device-tree).
> >
> > It would be nice to be able to have the console going that early,
> > unfortunately that would imply using the flat device-tree for the
> > parsing / matching of the stdout-path in those drivers.
> 
> I'm working on getting just that working. See my series for "generic
> earlycon". I'm working on cleaning up the FDT part still, but have
> something functional. The "hardest" part with FDT is doing the address
> translation for serial devices, but I just stole that from u-boot.

:-) There have been several use-cases wanting to property parse reg
properties from the flat tree recently. It would be good to get that as
a generic helper.

g.

