Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab3GWJC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:02:59 -0400
Received: from smtp-out-088.synserver.de ([212.40.185.88]:1092 "EHLO
	smtp-out-088.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3GWJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:02:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15694
Message-ID: <51EE46EA.1020809@metafoo.de>
Date: Tue, 23 Jul 2013 11:03:38 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@vger.kernel.org
Subject: Re: [PATCH v3] ARM: kirkwood: extend the kirkwood i2s driver for
 DT usage
References: <20130723104615.3696f1a9@armhf> <20130723085346.GQ24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130723085346.GQ24642@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 10:53 AM, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 10:46:15AM +0200, Jean-Francois Moine wrote:
>> The kirkwood i2s driver is used without DT in the Kirkwood machine.
>> This patch adds a DT compatible definition for use in other Marvell
>> machines as the Armada 88AP510 (Dove).
> 
> Yet again, this illustrates why converting to DT causes backwards
> steps in drivers: the conversion of devm_clk_get() to of_clk_get()
> necessitates a clk_put().

That's just a very poor usage of the API in this patch. devm_clk_get() works
fine on DT and non-DT platforms. The driver shouldn't need any changes in
that regard.

- Lars

