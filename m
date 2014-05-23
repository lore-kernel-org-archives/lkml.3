Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaEWRBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:01:52 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54986 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbaEWRBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:01:49 -0400
X-Sasl-enc: bOAjmdNzZUxAm5W8BMeWAIjleAN6Joa8pL9I65FSfNmt 1400864507
Date: Fri, 23 May 2014 14:01:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org, Burt Triplett <burt@pbjtriplett.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Intel microcode extended signature table support in Linux/BITS
Message-ID: <20140523170135.GA9563@khazad-dum.debian.net>
References: <20140221201547.GB722@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140221201547.GB722@khazad-dum.debian.net>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING?

On Fri, 21 Feb 2014, Henrique de Moraes Holschuh wrote:
> I am directing this question to you hoping one of you can either address it
> directly, or forward it internally at Intel.
> 
> We have code in the Linux kernel to support microcode extended signature
> tables which has never been tested as far as I know, as there are no public
> test vectors of microcode update containers with extended signature tables.
> 
> IMHO, untested kernel code is never a good thing, and useless untested
> kernel code is even worse.
> 
> So, the first question would be whether microcode extended signature tables
> are ever going to be used by Intel?
> 
> If that code is going to remain unused, we probably should remove support
> for Intel microcode extended signatures from Linux.
> 
> Anyway, there is an incompatibility between the code in Linux and also in
> Intel BITS, and what is documented in the SDM (Intel® 64 and IA-32
> Architectures Software Developer Manual).
> 
> So, for the second question, could someone at Intel please clarify the
> following point?
> 
> In the Intel® 64 and IA-32 Architectures Software Developer Manual (SDM) vol
> 3A page 9-30, table 9-6, last row, the description of the extended signature
> table checksum ("Checksum[n]" in table 9-6) makes it clear one is supposed
> to strip out the extended signature table entirely from the microcode
> container when one applies the extended signature to the main microcode
> header.
> 
> However, this removal of the extended signature table also implies in a
> change of the "Total Size" field of the main microcode header (table 9-6).
> Therefore, the "CheckSum[n]" field of table 9-6 has to take into account
> this change in the "Total Size" field.
> 
> Two public implementations of extended microcode signature table support
> (Linux kernel and Intel BITS) do NOT take into account the required change
> to "Total Size" in order to strip the extended microcode signature table,
> and thus will not validate microcode with extended signature tables that
> follow the SDM.
> 
> So, which is correct: the code in Linux and BITS, or the text of the SDM?
> 
> As a sidenote, the way the SDM documents the extended signature table
> implies no extra padding can be added after the extended signature table.
> 
> Such padding would be required to satisfy the SDM requirement that "Total
> Size" be a multiple of 1024, unless the padding is done inside the microcode
> opaque data itself (payload).  This seems suboptimal, as it ties the
> container strongly to the payload/opaque data... maybe the multiple-of-1024
> requirement for Total Size is superfluous for variable-size microcode
> containers?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
