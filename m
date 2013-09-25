Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3IYBem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:34:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53485 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab3IYBek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:34:40 -0400
Date: Tue, 24 Sep 2013 21:34:35 -0400 (EDT)
Message-Id: <20130924.213435.2244969028650079031.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: jeffrey.t.kirsher@intel.com, joe@perches.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        tushar.n.dave@intel.com, e1000-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] intel: Remove extern from function prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380061012.2736.57.camel@bwh-desktop.uk.level5networks.com>
References: <5ccc921af41a862fe969809228f029035f851502.1380056108.git.joe@perches.com>
	<1380060449.2189.6.camel@jtkirshe-mobl>
	<1380061012.2736.57.camel@bwh-desktop.uk.level5networks.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 24 Sep 2013 18:34:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 24 Sep 2013 23:16:52 +0100

> On Tue, 2013-09-24 at 15:07 -0700, Jeff Kirsher wrote:
>> On Tue, 2013-09-24 at 14:09 -0700, Joe Perches wrote:
>> > There are a mix of function prototypes with and without extern
>> > in the kernel sources.  Standardize on not using extern for
>> > function prototypes.
>> > 
>> > Function prototypes don't need to be written with extern.
>> > extern is assumed by the compiler.  Its use is as unnecessary as
>> > using auto to declare automatic/local variables in a block.
>> 
>> So you are able to confirm that all compilers make this assumption
>> correctly?  The initial reason for using extern was because not all
>> compilers made the assumption or made it correctly.
> 
> You are probably thinking of global variables, where declarations
> without either 'extern' or an initialiser might or might not be treated
> as 'common'.  On function declarations, 'extern' really is redundant.

Furthermore, these networking headers include existing generic kernel
headers which already have removed the 'extern' from function
declarations in certain cases.

So I don't think there isn't an issue, and if there is it has existed
already for some time. :-)
