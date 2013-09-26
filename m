Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3IZSVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:21:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3IZSVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:21:33 -0400
Subject: Re: [dtc PATCH V2] Warn on node name unit-address presence/absence mismatch
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org>
Date: Thu, 26 Sep 2013 13:21:23 -0500
Cc: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3D2FE31C-A6BB-4F70-9B3B-C55012CB56B3@codeaurora.org>
References: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 19, 2013, at 12:54 PM, Stephen Warren wrote:

> From: Stephen Warren <swarren@nvidia.com>
> 
> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
> node that has a reg property must include a unit address in its name
> with value matching the first entry in its reg property. Conversely, if
> a node does not have a reg property, the node name must not include a
> unit address.
> 
> Implement a check for this. The code doesn't validate the format of the
> unit address; ePAPR implies this may vary from (containing bus) binding
> to binding, so doing so would be much more complex.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Implement the new checks separately, rather than as part of existing
>    checkes. downgrade from errors to warnings. Add tests.
> 
> Question: Do I need to make a special exception for the /memory node? I
> assume we do want to fix that too, so the answer is no. That will require
> removing the /memory node from skeleton.dtsi in the kernel though.
> ---
> checks.c                        | 22 ++++++++++++++++++++--
> tests/reg-without-unit-addr.dts | 10 ++++++++++
> tests/run_tests.sh              |  2 ++
> tests/unit-addr-without-reg.dts |  9 +++++++++
> 4 files changed, 41 insertions(+), 2 deletions(-)
> create mode 100644 tests/reg-without-unit-addr.dts
> create mode 100644 tests/unit-addr-without-reg.dts

What about the case of no reg but a ranges?

This pattern shows up on a lot (if not all) the PPC dts:

arch/powerpc/boot/dts/mpc8544ds.dts:

        board_soc: soc: soc8544@e0000000 {
                ranges = <0x0 0x0 0xe0000000 0x100000>;
        };

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

