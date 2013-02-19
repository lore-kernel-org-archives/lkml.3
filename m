Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab3BSSGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:06:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3BSSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:06:11 -0500
Date: Tue, 19 Feb 2013 13:06:07 -0500 (EST)
Message-Id: <20130219.130607.100487415380997622.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: JBeulich@suse.com, drjones@redhat.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: netback: remove redundant xenvif_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361264324.1051.61.camel@zakaz.uk.xensource.com>
References: <20130219.005356.2288460992654639558.davem@davemloft.net>
	<51233FF502000078000BF4AE@nat28.tlf.novell.com>
	<1361264324.1051.61.camel@zakaz.uk.xensource.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 10:06:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Tue, 19 Feb 2013 08:58:44 +0000

> On Tue, 2013-02-19 at 08:03 +0000, Jan Beulich wrote:
>> >>> On 19.02.13 at 06:53, David Miller <davem@davemloft.net> wrote:
>> > From: Andrew Jones <drjones@redhat.com>
>> > Date: Mon, 18 Feb 2013 21:29:20 +0100
>> > 
>> >> netbk_fatal_tx_err() calls xenvif_carrier_off(), which does
>> >> a xenvif_put(). As callers of netbk_fatal_tx_err should only
>> >> have one reference to the vif at this time, then the xenvif_put
>> >> in netbk_fatal_tx_err is one too many.
>> >> 
>> >> Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > 
>> > Applied.
>> 
>> But this is wrong from all we can tell,
> 
> Yes, please can this be reverted.

Done and I've annotated the revert commit message with as much
information as possible.
