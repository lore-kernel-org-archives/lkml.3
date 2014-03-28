Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaC1Vde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:33:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:55042 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbaC1Vdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:33:33 -0400
Message-ID: <1396042396.11529.27.camel@pasglop>
Subject: Re: [RFC 1/5] of: Add support for ePAPR "stdout-path" property
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, rob.herring@linaro.org
Date: Sat, 29 Mar 2014 08:33:16 +1100
In-Reply-To: <1396022885-6102-2-git-send-email-grant.likely@linaro.org>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
	 <1396022885-6102-2-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 09:08 -0700, Grant Likely wrote:
> ePAPR 1.1 defines the "stdout-path" property for specifying the console
> device, but Linux currently only handles the older "linux,stdout-path"
> property. This patch adds parsing for the new property name.

Generally a good idea I think, but of course I need time to review and
test ... :-)

One thing that's been annoying me lately with the existing code which
you don't address is ... in a few cases my consoles are usable *VERY*
early. For example PAPR hvc and OPAL hvc can be used before we even turn
the MMU on on powerpc (and thus before we unflatten the device-tree).

It would be nice to be able to have the console going that early,
unfortunately that would imply using the flat device-tree for the
parsing / matching of the stdout-path in those drivers.

Right now, I have this explicit config option to hard wire "early debug"
but there are a few cases of field bugs that can happen in early init
code which I'd like to see logged properly on those systems, and early
debug isn't suitable for field use...

Cheers,
Ben.


