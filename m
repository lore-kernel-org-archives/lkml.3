Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaHAOMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:12:39 -0400
Received: from stinky.trash.net ([213.144.137.162]:55455 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaHAOMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:12:38 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140801134901.GD7331@casper.infradead.org>
References: <cover.1406891028.git.tgraf@suug.ch> <bd4d9fa542072358cb0bd77e493ec5785a1d9666.1406891028.git.tgraf@suug.ch> <53DB864B.2070205@redhat.com> <20140801134901.GD7331@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH net-next 3/3] nftables: Convert nft_hash to use generic rhashtable
From: Patrick McHardy <kaber@trash.net>
Date: Fri, 01 Aug 2014 15:12:28 +0100
To: Thomas Graf <tgraf@suug.ch>, Nikolay Aleksandrov <nikolay@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Message-ID: <0d77fb6a-4465-432f-9d6a-b1c1497a780b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1. August 2014 14:49:01 GMT+01:00, Thomas Graf <tgraf@suug.ch> wrote:
>On 08/01/14 at 02:21pm, Nikolay Aleksandrov wrote:
>> Sorry for the late response but I just got around to check the 3rd
>patch now,
>> so my question about this fragment is: before nft_hash_remove() would
>free the
>> element after removal, but after this change I don't see where and
>when the
>> removed element would get freed ?
>
>You are right. Looking at this closer we were leaking references even
>before the change because it would not call nft_data_uninit() to
>release
>the data objects. So it should really just call
>nft_hash_elem_destroy().

No, the data uninit is performed by the set core. Just freeing it is fine.


