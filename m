Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaEBSYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:24:43 -0400
Received: from smtp.newterm.pl ([79.187.237.18]:48613 "EHLO apollo.newterm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaEBSYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:24:38 -0400
Date: Fri, 2 May 2014 20:24:37 +0200
From: Darek Marcinkiewicz <reksio@newterm.pl>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] Driver for Beckhoff CX5020 EtherCAT master module.
Message-ID: <20140502182437.GC1156@newterm.pl>
References: <20140501062047.GA1156@newterm.pl>
 <20140501155331.GA6523@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501155331.GA6523@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. Thank you for your comments.

On Thu, May 01, 2014 at 05:53:31PM +0200, Francois Romieu wrote:
> Darek Marcinkiewicz <reksio@newterm.pl> :
> [changes]
> 
[...]
> 
> > +
> > +struct bh_priv {
> 
> Nit: it would be nice to avoid "_bh_" as it is already used in a set of
> common kernel functions.
> 
I renamed bh to bhf and as result also changed the driver name - to ec_bhf.
> [...]
> > +	u8 *tx_put;
> > +	u8 *tx_get;
> 
> It's part u8 and part tx_header.
> 
> You may consider using a struct that adds an extra 'u8 data[0]' at
> the end of the struct tx_header.
> 
> skb_copy_and_csum_dev in the xmit path rings a bell but the DMA FIFO
> zone handling could imho save some pointer arithmetic and turn a bit
> more literate.
> 
I did some rework of descriptors handling and they are now kept in
a list so no pointer arithmetic at all.

As for the rest of your comments - all of them are incorporated
in next revision of the patch.

Thank you.

-- 
DM

-- 
DM
