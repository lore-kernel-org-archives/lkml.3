Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaFYWbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:31:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38742 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaFYWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:31:12 -0400
Date: Wed, 25 Jun 2014 15:31:09 -0700 (PDT)
Message-Id: <20140625.153109.1658452238116055408.davem@davemloft.net>
To: joe@perches.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403733111.24788.8.camel@joe-AO725>
References: <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
	<20140625122755.152685fadbc9cffe7a298dc6@linux-foundation.org>
	<1403733111.24788.8.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 15:31:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 25 Jun 2014 14:51:51 -0700

> On Wed, 2014-06-25 at 12:27 -0700, Andrew Morton wrote:
>> On Mon, 23 Jun 2014 06:41:29 -0700 Joe Perches <joe@perches.com> wrote:
>> 
>> > Add this helper for consistency with pci_zalloc_coherent
>> > and the ability to remove unnecessary memset(,0,) uses.
>> 
>> While we're being anal..  I'm not a big fan of the patch titles.  Worst
>> is "amd: Use pci_zalloc_consistent".  "amd" is quite a poor identifier
>> - it's only when you get in and look at the diff that you realise it's
>> an ethernet driver.
> 
> Yeah, those "amd:" prefixes should really have been "pcnet32:"
> 
>> People sometimes address this by using
>> 
>> 	"drivers: net: ethernet: amd: use pci_zalloc_consistent"
>> 
>> which strikes me as utterly perverse.  We already have a nice way of
>> representing the hierarchy and that's using '/'.
> 
> I used to do that until several people complained.
> Now I don't.  btw:  Documentation/SubmittingPatches says:
> 
> 15) The canonical patch format
> 
> The canonical patch subject line is:
> 
>     Subject: [PATCH 001/123] subsystem: summary phrase

+1

We've been representing subsystems using colon prefixes for ages, and
I can't seen the value of starting to use something inconsistent with
a decade of precedence.
