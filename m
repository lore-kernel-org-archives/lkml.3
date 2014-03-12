Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaCLWHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:07:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61965 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaCLWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:07:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com>
References: <1394658311-17769-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1394658311-17769-2-git-send-email-jgunthorpe@obsidianresearch.com> <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 12 Mar 2014 15:06:34 -0700
Message-ID: <CAGVrzcYVK6baunDFzyTm58-+=cw14nvQn9+rFFPca_YUnmbJ=A@mail.gmail.com>
Subject: Re: [PATCH v2a RESEND 2/2] of_mdio: Allow the DT to specify the phy
 ID and avoid autoprobing
To: Rob Herring <robherring2@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-12 14:35 GMT-07:00 Rob Herring <robherring2@gmail.com>:
> On Wed, Mar 12, 2014 at 4:05 PM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
>> This makes the generic of_mdiobus_register parse the DT compatible string for
>> the pattern ethernet-phy-idAAAA.BBBB. If present it should be a value that
>> matches the phy-id register normally readable through MDIO.
>>
>> When the ID is given the phy autoprobing is defeated and the phy is
>> created directly.
>>
>> This is necessary to support phy's that cannot be autoprobed when
>> of_mdiobus_register is called. Specifically, my case has the phy in reset at
>> of_mdiobus_register, the reset is only released once the ethernet driver
>> starts, before it attaches to the phy.
>>
>> Tested on ARM Kirkwood with phy id 0x01410e90 (Marvell 88E1318)
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/of/of_mdio.c | 30 +++++++++++++++++++++++++++++-
>>  1 file changed, 29 insertions(+), 1 deletion(-)
>>
>> There was some reworking of the original code in v3.14-rc6, this resolves the
>> merge conflicts and I retested the resolved patch on Kirkwood.
>>
>> Florian, do you know what path to mainline a this patch should take?
>
> Via David's net tree.

In that case, this is probably more relevant for the 'net-next' tree
since it is not a bug fix and we are fairly late in the 3.14 cycle?
-- 
Florian
