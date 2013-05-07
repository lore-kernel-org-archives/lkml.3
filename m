Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3EGVJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:09:37 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:37394
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab3EGVJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:09:36 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh906i1155h)
Date: Tue, 7 May 2013 14:08:57 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Always notify whole subtree when reparenting
References: <afe397e3-c674-4dc3-9f3e-feea9275bb91@TX2EHSMHS023.ehs.local>
 <20130507205953.4542.62609@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130507205953.4542.62609@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <4ee1b52e-8c1d-4161-9034-62fc6c48fd12@CO9EHSMHS026.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:59:53PM -0700, Mike Turquette wrote:
> Quoting Soren Brinkmann (2013-04-16 10:06:50)
> > A clock's notifier count only reflects notifiers which are registered
> > directly for that clock. A reparent operation though affects the whole
> > subtree because of a potential rate change.
> > When issuing the pre rate change notifications only the notifier count
> > for the clock to be changed is considered and notifiers for subclocks
> > may never be called. Resulting in clocks in the subtree which have
> > registered notifiers, may receive a POST_- or ABORT_RATE_CHANGE
> > notification, without a PRE_RATE_CHANGE_NOTIFICATION.
> > Therefore always traverse the whole subtree when issueing pre rate
> > change notifications during a reparent operation.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > This should probably be considered an RFC. There may be smarter ways to
> > resolve this issue. E.g. forward notifier counts upstream the way it is done
> > with enable counts.
> > 
> 
> I've taken this patch for 3.11.
thank you.

	Sören


