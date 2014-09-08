Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaIHXVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:21:03 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:31326 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755079AbaIHXVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:21:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xMRqSU1BP6r8zb2C0bM6t
Date: Mon, 8 Sep 2014 16:20:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        Markus Mayer <markus.mayer@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv3 0/5] OMAP Mailbox framework adoption & DT support
Message-ID: <20140908232053.GS3238@atomide.com>
References: <1406680479-18446-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406680479-18446-1-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suman Anna <s-anna@ti.com> [140729 17:37]:
> Hi,
> 
> This is an updated version of the OMAP Mailbox framework adoption &
> DT support series, refreshed to work with the v9 version of the mailbox
> framework [1] from Jassi Brar while also addressing some minor review
> comments. Detailed changes are summarized below. Patches are based on
> 3.16-rc2.

Sorry for the delay, just noticed that I'm supposed to queue
these too. I'll queue these into omap-for-v3.18/mailbox against
v3.17-rc1 and will probably also merge it into omap-for-v3.18/dt
as well.

Regards,

Tony
 
> The series depends on the OMAP mailbox DT/hwmod cleanup series [2] and the
> OMAP mailbox cleanup series [3]. Both these series are staged to be merged
> for 3.17 [4]. The last 2 framework adaptation patches require the v9 framework
> patches to build successfully. The reference branch with all the patches is
> hosted (not for merging - includes an additional patch for dsp/bridge changes) at 
> https://github.com/sumananna/mailbox/commits/submit/3.16-rc2-omap-mbox-v9-fwk-v3
> 
> The AM335 PM suspend series [5] which relies on this series needs to have
> the wkupm3 node updated to use the new property name "mboxes" instead of
> "mbox", and use the updated mbox_request_channel API.
> 
> Changes in v3:
> - Revised the OMAP mailbox bindings to reflect the updated compatible
>   strings (Patch 1) and the updated common mailbox properties in
>   the v9 framework (Patch 4)
> - Code rearrangement/flip of if code blocks in omap_mailbox probe to address
>   Markus Mayer's comments from v2 (Patch 2)
> - omap_mbox_of_xlate updated to add a missing of_node_put (Patch 4)
> - Adjust the added OMAP non-DT support API, omap_mbox_request_channel, to
>   handle the loss of the chan_name field in the mbox_client structure
>   from v8 to v9 of mailbox framework (Patch 4)
> - Dropped mailbox adaptation changes to TI DSP/Bridge driver, as it will be
>   deleted in 3.17 (Patch 4)
> - No changes to DTS patches (Patches 3 and 5)
> - Tested against v9 of mailbox framework
> 
> v2:
> - http://www.spinics.net/lists/linux-omap/msg109379.html
> - Updated the OMAP DT bindings document for the added back DT properties:
>   "ti,mbox-num-users" and "ti,mbox-num-fifos". Also added information
>   regarding "#mbox-cells" and DT client usage.
> - Updated the OMAP DT adaptation patch to parse the added back DT properties
>   and clean up the previous match data structure.
> - Squashed custom xlate patch into the framework adaptation patch.
> - Tested against v8 of mailbox framework.
> 
> v1:
> - http://www.spinics.net/lists/linux-omap/msg108595.html
> - Tested against v7 of mailbox framework
> 
> 
> The following shows the boot/validation logs on various OMAP platforms:
>   OMAP2 (SDP2430)           : http://slexy.org/view/s20ZcIovmA
>   OMAP3 (BeagleXM)          : http://slexy.org/view/s2jWS6RPDJ
>   OMAP4 (PandaBoard)        : http://slexy.org/view/s21Mxi3Z4v
>   OMAP5 (OMAP5 uEVM)        : http://slexy.org/view/s2EUjy49h9
>   DRA7  (DRA7 EVM)          : http://slexy.org/view/s29ehoRZWl
>   AM33xx (BeagleBone Black) : http://slexy.org/view/s20A8RDPRy
>   AM43xx (AM437x GP EVM)    : http://slexy.org/view/s21HMTnL2t
> 
> [1] https://lkml.org/lkml/2014/7/22/613
> [2] http://marc.info/?l=linux-omap&m=140511512208519&w=2
> [3] http://www.spinics.net/lists/linux-omap/msg108574.html
> [4] https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/log/?h=omap-for-v3.17/mailbox
> [5] http://www.spinics.net/lists/linux-omap/msg109331.html
> 
> Suman Anna (5):
>   Documentation: dt: add omap mailbox bindings
>   mailbox/omap: add support for parsing dt devices
>   ARM: dts: OMAP2+: Add sub mailboxes device node information
>   mailbox/omap: adapt to the new mailbox framework
>   ARM: dts: OMAP2+: Add #mbox-cells property to all mailbox nodes
> 
>  .../devicetree/bindings/mailbox/omap-mailbox.txt   | 132 ++++++
>  arch/arm/boot/dts/am33xx.dtsi                      |   5 +
>  arch/arm/boot/dts/am4372.dtsi                      |   5 +
>  arch/arm/boot/dts/dra7.dtsi                        |  13 +
>  arch/arm/boot/dts/omap2420.dtsi                    |   9 +
>  arch/arm/boot/dts/omap2430.dtsi                    |   5 +
>  arch/arm/boot/dts/omap3.dtsi                       |   5 +
>  arch/arm/boot/dts/omap4.dtsi                       |   9 +
>  arch/arm/boot/dts/omap5.dtsi                       |   9 +
>  drivers/mailbox/omap-mailbox.c                     | 502 ++++++++++++++-------
>  drivers/remoteproc/omap_remoteproc.c               |  51 ++-
>  include/linux/omap-mailbox.h                       |  16 +-
>  12 files changed, 557 insertions(+), 204 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/omap-mailbox.txt
> 
> -- 
> 2.0.0
> 
