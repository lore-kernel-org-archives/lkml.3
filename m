Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbaFJEIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:08:52 -0400
Received: from mx1.scotdoyle.com ([69.85.92.149]:54717 "EHLO mx1.scotdoyle.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaFJEIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:08:51 -0400
Date: Tue, 10 Jun 2014 06:08:49 +0100 (BST)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] platform/chrome: Probe multiple i2c adapters of the
 same name
In-Reply-To: <20140609124700.GJ1657@lahna.fi.intel.com>
Message-ID: <alpine.DEB.2.02.1406092332410.8274@scotdoyle.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com> <CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com> <20140604083726.GN1730@lahna.fi.intel.com> <CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
 <alpine.DEB.2.02.1406062259070.31301@scotdoyle.com> <alpine.DEB.2.02.1406062316230.32568@scotdoyle.com> <20140609124700.GJ1657@lahna.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's a good point, I'll submit a new patch which documents this 
requirement. If this isn't a sufficiently robust solution, I 
understand.

On Mon, 9 Jun 2014, Mika Westerberg wrote:

> On Fri, Jun 06, 2014 at 11:25:14PM +0100, Scot Doyle wrote:
>> The chromeos_laptop module probes the first i2c 
adapter with a specific name
>> for expected hardware. However, the Acer C720 Chromebook has two i2c
>> adapters with the same name. This patch probes each i2c adapter with a
>> specific name in turn, until locating the expected hardware.
>>
>> Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
>> CC: Benson Leung <bleung@chromium.org>
>> CC: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> I don't have anything against this approach.
>
> One comment though, if you happen to have two devices with the same
> address but in different buses this can go wrong. Not sure how likely
> that will happen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
