Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3EHUKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:10:13 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:29337
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900Ab3EHUKL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:10:11 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Wed, 8 May 2013 13:10:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Chris Mason <clmason@fusionio.com>
CC: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] Fix crash during slab init
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com>
 <20130508042422.GU28721@atomide.com>
 <20130508181353.23991.17852@localhost.localdomain>
 <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
 <20130508184817.4271.72594@localhost.localdomain>
 <0000013e85852607-fd84223c-112e-46b9-a60f-73d9597d90ac-000000@email.amazonses.com>
 <20130508195628.4271.97115@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130508195628.4271.97115@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <90ceb287-c74e-404d-ab10-903a41ed7e6e@DB8EHSMHS010.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 03:56:28PM -0400, Chris Mason wrote:
> Commit 8a965b3b introduced a regression that caused us to crash early
> during boot.  The commit was introducing ordering of slab creation,
> making sure two odd-sized slabs were created after specific powers of
> two sizes.
> 
> But, if any of the  power of two slabs were created earlier during boot,
> slabs at index 1 or 2 might not get created at all.  This patch makes
> sure none of the slabs get skipped.
> 
> Tony Lindgren bisected this down to the offending commit, which really
> helped because bisect kept bringing me to almost but not quite this one.
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Fixes things for me on Zynq, too.

	Sören


