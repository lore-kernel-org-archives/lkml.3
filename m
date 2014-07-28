Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaG1PjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:39:16 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54608 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbaG1PjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:39:15 -0400
X-Sasl-enc: MDPucMR5bVOFZwmU7OYX2K+kuLfn8TRnOQm0XrBhSrfv 1406561951
Date: Mon, 28 Jul 2014 12:39:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: total_size is valid only when
 data_size != 0
Message-ID: <20140728153905.GB9752@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-7-git-send-email-hmh@hmh.eng.br>
 <20140725164614.GE4421@pd.tnic>
 <20140725190411.GA21416@khazad-dum.debian.net>
 <20140728142640.GB5350@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728142640.GB5350@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Borislav Petkov wrote:
> On Fri, Jul 25, 2014 at 04:04:11PM -0300, Henrique de Moraes Holschuh wrote:
> > As far as I can tell, Intel has always filled the reserved fields in the
> > microcode data files with zeros.
> 
> Yes, and this is the statement I was looking for. IF(!) this really
> is the case, then we don't have anything to worry about because new
> kernel with old container will look at ->datasize, see 0 and return
> DEFAULT_UCODE_TOTALSIZE and we're fine.

We're fine AFAICT.

If there's an official microcode update out there that can trigger this
bug, it didn't come from a Linux distro, from Intel's public download site
or from urbanmyth.org.

I've checked 346 unique microcode updates for 189 unique Intel processors,
and none would cause problems.  That test corpus covers processors as old
as cpuid 0x611.  It is used to check iucode-tool for regressions.

> I've updated the patch with your additional explanation.

Thank you!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
