Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaIVOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:09:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaIVOJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:09:55 -0400
Date: Mon, 22 Sep 2014 16:09:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Ping Cheng <pinglinux@gmail.com>, killertofu@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: fix timeout on probe for some wacoms
In-Reply-To: <1410900999-24692-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1409221608420.5523@pobox.suse.cz>
References: <1410900999-24692-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Benjamin Tissoires wrote:

> Some Wacom tablets (at least the ISDv4 found in the Lenovo X230) timeout
> during probe while retrieving the input reports.
> The only time this information is valuable is during the feature_mapping
> stage, so we can ask for it there and discard the generic input reports
> retrieval.
> 
> This gives a code path closer to the wacom.ko driver when it was in the
> input subtree (not HID).
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> I run into this today while trying to improve the generic support of the ISDv4
> sensors (those found on laptops not sold by Wacom).
> This is a regression from 3.16, in a sense that it can add up to 10 seconds to
> the boot of the laptop. So IMO, this should go as a fix for 3.17-rc6.
> 
> Unfortunately, c64d883476 changed the ABI and wacom_get_report() takes now one
> less argument. I based my patch on top of the for-3.18/wacom branch, so in 3.17,
> it will not compile.
> I would personally be in favor of having c64d883476 and this one in 3.17, but
> c64d883476 will also require some manual conflict resolution (cherry-pick is
> complaining).
> I can also resend it based on the v3.17-rc5 tag, but then we will have to update
> the for-3.18/wacom when you will merge with Linus' tree.

Hi Benjamin,

c64d883476 is not really a rc7 material, so I'd not like to be 
cherry-picking it for this.

My take on this would actually be to apply to for-3.18/wacom, mark it for 
stable, and then make sure that c64d883476 makes it to the first 
3.17-stable.

What do you think?

-- 
Jiri Kosina
SUSE Labs
