Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbaCOPeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:34:18 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51043 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaCOPeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <1394896841.30941.4.camel@jlt4.sipsolutions.net>
References: <20140305125703.GA7193@localhost> <20140305132317.GB10880@localhost>
 <20140308121138.GA8359@localhost> <20140312173446.GD2983@piware.de>
 <CABPxzYLJA-gQjw2CwmL63dYEQ35h073k_vsp1uEM0B-sAmEwKQ@mail.gmail.com> <1394896841.30941.4.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 15 Mar 2014 21:03:54 +0530
Message-ID: <CABPxzYJXQR=t6u33uFT5dU2y6sKK1QhCbBn+t4TmmNfVhNk5gw@mail.gmail.com>
Subject: Re: [mac80211_hwsim] BUG: unable to handle kernel paging request at ce1db404
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Martin Pitt <martin.pitt@ubuntu.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 8:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Thu, 2014-03-13 at 02:15 +0530, Krishna Chaitanya wrote:
>
> > From the logs it looks like "rate_control_alloc" is failed,
> > causing ieee80211_register_hw to fail triggering the crash.
>
> Yes.
>
> > what RC are u using? Default should be minstrel, i dont see
> > a reason for rc alloc to fail (remote reason kmalloc failure),
> > so did you disable RC completely? No prints either w.r.t RC either in
> > dmesg?
>
> Pay attention to the .config.
>
Missed the attachment, thanks for pointing.
As guessed the rate control is empty causing the registration fail.

CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""
