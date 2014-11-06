Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaKFF3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:29:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49873 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKFF3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:29:05 -0500
Message-ID: <545B071E.7090007@wwwdotorg.org>
Date: Wed, 05 Nov 2014 22:29:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>
CC: linux-rpi-kernel@lists.infradead.org, lee@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
In-Reply-To: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 04:45 PM, Matthias Klein wrote:
> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
> I2S interface.

BTW, according to:

http://raspberryalphaomega.org.uk/2013/02/06/automatic-raspberry-pi-board-revision-detection-model-a-b1-and-b2/

... there are actually 2 different HW configurations we care about for
the pre-plus Pis:

B rev 1
A, or B rev 2

I guess we should have separate device trees for those, since there are
some differences in the GPIO and I2C channel usage. That'd leave us with:

bcm2835-rpi-b.dts (Pin3=GPIO0, Pin5=GPIO1, Pin13=GPIO21, I2C-0)
bcm2835-rpi-b-rev2.dts (Pin3=GPIO1, Pin5=GPIO2, Pin13=GPIO27, 12C-1)
bcm2835-rpi-b-plus.dts (TBD pending schematic or equivalent info)
... and probably another for the compute board.

We can ignore RAM size differences, since these are automatically filled
into the /memory node in DT. I'm not sure if A-vs-B-rev-1 is
interesting. Perhaps we should have separate DTs just in case, since we
may need to represent the LAN_RUN GPIO in DT at some point, and that
only applies to the B.

Presumably, the boot loader would automatically query the VC firmware
for the board revision data, and dynamically load the appropriate DT
filename.

Any thoughts or objections?
