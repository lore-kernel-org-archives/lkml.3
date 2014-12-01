Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaLAHeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 02:34:12 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:6966 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaLAHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 02:34:10 -0500
X-IronPort-AV: E=Sophos;i="5.07,492,1413270000"; 
   d="scan'208";a="51929533"
Message-ID: <547C19ED.10201@broadcom.com>
Date: Mon, 1 Dec 2014 08:34:05 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Felix Fietkau" <nbd@openwrt.org>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the net-next
 tree
References: <20141201181933.6dfaad66@canb.auug.org.au>
In-Reply-To: <20141201181933.6dfaad66@canb.auug.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-12-14 08:19, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/net/wireless/ath/ath9k/debug.c between commits 70e535ed0029
> ("ath9k: clean up debugfs print of reset causes"), 7b8aaead958e
> ("ath9k: restart hardware after noise floor calibration failure") and
> 325e18817668 ("ath9k: fix misc debugfs when not using chan context")
> from the net-next tree and commit 631bee257bd5 ("ath: use seq_file api
> for ath9k debugfs files") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> Greg, I am not sure why those 2 commits are even in your tree.  Do they
> depend on something else in your tree?

They do. The three commits below are related:

d32394f ath: ath9k: use debugfs_create_devm_seqfile() helper for
seq_file entrie
631bee2 ath: use seq_file api for ath9k debugfs files
98210b7 debugfs: add helper function to create device related seq_file

The ath patches were made to provide example of using the new helper
function and get some idea about code savings. Greg and John discussed
who would take them. I noticed other ath changes in net-next so I kinda
expected this email ;-)

Regards,
Arend
