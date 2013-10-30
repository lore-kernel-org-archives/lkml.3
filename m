Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3J3Jj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:39:57 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38669 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3J3Jj4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 30 Oct 2013 05:39:56 -0400
Message-Id: <5270E1F902000078000FDFCA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 30 Oct 2013 09:39:53 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Zoltan Kiss" <zoltan.kiss@citrix.com>
Cc: <ian.campbell@citrix.com>, <jonathan.davies@citrix.com>,
        <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next RFC 3/5] xen-netback: Remove
 old TX grant copy definitons
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com>
 <1383094220-14775-4-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1383094220-14775-4-git-send-email-zoltan.kiss@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.10.13 at 01:50, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> These became obsolate with grant mapping.

I didn't look at this in detail, but I'm surprised you can get away
without any copying: For one, the header part needs copying
anyway, so you'd pointlessly map and then copy it if it's small
enough. And second you need to be prepared for the frontend
to hand you more slots than you can fit in MAX_SKB_FRAGS
(namely when MAX_SKB_FRAGS < XEN_NETIF_NR_SLOTS_MIN),
which you can't handle with mapping alone afaict.

Jan


