Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaC2Aa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:30:56 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35086 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaC2Aay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:30:54 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 1/5] of: Add support for ePAPR "stdout-path" property
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, rob.herring@linaro.org
In-Reply-To: <1396042396.11529.27.camel@pasglop>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org> < 1396022885-6102-2-git-send-email-grant.likely@linaro.org> <1396042396.11529 .27.camel@pasglop>
Date: Fri, 28 Mar 2014 17:30:50 -0700
Message-Id: <20140329003050.C5A31C434EC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2014 08:33:16 +1100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2014-03-28 at 09:08 -0700, Grant Likely wrote:
> > ePAPR 1.1 defines the "stdout-path" property for specifying the console
> > device, but Linux currently only handles the older "linux,stdout-path"
> > property. This patch adds parsing for the new property name.
> 
> Generally a good idea I think, but of course I need time to review and
> test ... :-)
> 
> One thing that's been annoying me lately with the existing code which
> you don't address is ... in a few cases my consoles are usable *VERY*
> early. For example PAPR hvc and OPAL hvc can be used before we even turn
> the MMU on on powerpc (and thus before we unflatten the device-tree).
> 
> It would be nice to be able to have the console going that early,
> unfortunately that would imply using the flat device-tree for the
> parsing / matching of the stdout-path in those drivers.

I think we can get that done. Rob's series goes a long way to that, and
I don't think the flattree parsing will be all that complex.

g.

