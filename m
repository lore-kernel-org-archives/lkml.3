Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaHANtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:49:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:52679 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHANtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:49:04 -0400
Date: Fri, 1 Aug 2014 14:49:01 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Nikolay Aleksandrov <nikolay@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] nftables: Convert nft_hash to use generic
 rhashtable
Message-ID: <20140801134901.GD7331@casper.infradead.org>
References: <cover.1406891028.git.tgraf@suug.ch>
 <bd4d9fa542072358cb0bd77e493ec5785a1d9666.1406891028.git.tgraf@suug.ch>
 <53DB864B.2070205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DB864B.2070205@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 at 02:21pm, Nikolay Aleksandrov wrote:
> Sorry for the late response but I just got around to check the 3rd patch now,
> so my question about this fragment is: before nft_hash_remove() would free the
> element after removal, but after this change I don't see where and when the
> removed element would get freed ?

You are right. Looking at this closer we were leaking references even
before the change because it would not call nft_data_uninit() to release
the data objects. So it should really just call nft_hash_elem_destroy().
