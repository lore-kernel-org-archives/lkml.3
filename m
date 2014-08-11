Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaHKNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:16:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45876 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbaHKNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:16:26 -0400
X-Sasl-enc: squzBDKeA8cvGchMtPD4w/MzI483gCb7Roh4EVZYwJBq 1407762985
Date: Mon, 11 Aug 2014 10:16:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: H Peter Anvin <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: early intel microcode update violating alignment rules
Message-ID: <20140811131613.GA4541@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140811102245.GC4236@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811102245.GC4236@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, Borislav Petkov wrote:
> On Sat, Aug 09, 2014 at 08:19:11PM -0300, Henrique de Moraes Holschuh wrote:
> > Is there a way to fix this in the kernel for the BSP?
> 
> I think you're looking at this the wrong way around. :-) The thing that
> needs fixing is the SDM since some CPUs seem to accept 16-byte unaligned
> microcode just fine.

I often wonder how much of the Intel SDM is really a fairy tale...  it
certainly has enough legends from times long past inside ;-)  But just like
old stories, should you forget all about them, they sometimes grow fangs
back and get you when you're least prepared.

Now, seriously, we're neither aligning the thing, nor checking any of it for
alignment, so userspace can mess with us at will.  Unless it is trying to be
actively malicious, we'll get 4-byte alignment out of userspace for the data
inside the early initramfs (assuming the use of the common cpio tools: GNU
cpio and GNU pax), but that's it.

I can easily propose fixes to reject incorrectly aligned data (and will do
so), but you *really* don't want to know the kind of crap I came up with to
try to align the microcode update for the BSP: Standard Lovecraftian Mythos
Safety Procedures apply!  So I am turning to you for ideas...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
