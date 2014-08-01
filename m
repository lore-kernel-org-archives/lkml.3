Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaHAK2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:28:47 -0400
Received: from stinky.trash.net ([213.144.137.162]:54120 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbaHAK2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:28:46 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <ea51f2fdfb1ce84ff109d03bf37811e4b24135c5.1406882738.git.tgraf@suug.ch>
References: <cover.1406882738.git.tgraf@suug.ch><cover.1406882738.git.tgraf@suug.ch> <ea51f2fdfb1ce84ff109d03bf37811e4b24135c5.1406882738.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH net-next 3/3] nftables: Convert nft_hash to use generic rhashtable
From: Patrick McHardy <kaber@trash.net>
Date: Fri, 01 Aug 2014 11:17:03 +0100
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, tklauser@distanz.ch,
        netfilter-devel@vger.kernel.org
Message-ID: <970429e5-2465-40f2-998b-b82dab3debe8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1. August 2014 09:52:00 GMT+01:00, Thomas Graf <tgraf@suug.ch> wrote:
>If the set size is known in advance, the table is sized accordingly,
>otherwise the table size will default to 64. This is a slight change
>in behaviour as previously the default was 4 which eventually required
>many expansion iterations.

That's assuming a sufficient number of entries will be added. I think there
will be many cases in nftables where the number will be lower. Since
expansion is not very expansive this number was chosen very deliberately
and I'd prefer to keep it.

Other than that:

Acked-by: Patrick McHardy <kaber@trash.net>

