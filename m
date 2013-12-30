Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3L3S4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:56:18 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:43533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3L3S4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:56:16 -0500
Message-ID: <1388429761.4410.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Dec 2013 19:56:01 +0100
In-Reply-To: <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr> (sfid-20131230_182319_112673_F481A1D3)
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
	 (sfid-20131230_182319_112673_F481A1D3)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-30 at 19:15 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Ether_addr_equal_64bits is more efficient than ether_addr_equal, and can be
> used when each argument is an array within a structure that contains at
> least two bytes of data beyond the array.
> 
> The structures involved are:
> iwl_rxon_cmd defined in drivers/net/wireless/iwlwifi/dvm/commands.h and
> ieee80211_hdr defined in include/linux/ieee80211.h
> 
> This was done using Coccinelle (http://coccinelle.lip6.fr/).

Seems to be missing an "iwlwifi:" or so prefix, but I guess we can add
it when we take the patch ...

Is there any way we could catch (sparse, or some other script?) that
struct reorganising won't break the condition needed ("within a
structure that contains at least two more bytes")?

johannes

