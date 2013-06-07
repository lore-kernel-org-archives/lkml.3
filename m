Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3FGH4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:56:36 -0400
Received: from mail.abilis.ch ([195.70.19.74]:26460 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3FGH4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:56:34 -0400
Date: Fri, 7 Jun 2013 09:55:29 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: designware: make i2c xfers non-interruptible
Message-ID: <20130607075527.GB11875@ab42.lan>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
 <1370526216-10060-2-git-send-email-christian.ruppert@abilis.com>
 <20130607052555.GC11878@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130607052555.GC11878@intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 08:25:55AM +0300, Mika Westerberg wrote:
> On Thu, Jun 06, 2013 at 03:43:36PM +0200, Christian Ruppert wrote:
> > When the process at the source of an i2c transfer is killed in the
> > middle of the transfer, the transfer is interrupted. Interrupted
> > transfers might cause buggy slaves on the bus (or higher level drivers)
> > to go haywire.
> > This patch forces ongoing i2c transfers to finish properly, even if the
> > initiating process is killed.
> 
> I already sent a similar patch ;-)
> 
> https://patchwork.kernel.org/patch/2601241/
> 
> However, it is not yet picked by Wolfram.

Oops, this looks like a human race condition :) I checked main line and
Wolfram's git but didn't think of checking patchwork. I'll rebase the
second patch on yours.

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
