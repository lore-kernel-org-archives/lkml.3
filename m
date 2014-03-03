Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaCCTHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:07:44 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:50285 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaCCTHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:07:41 -0500
X-Auth-Info: TSaiCeY4L+t/D/itG7TXrICDxb6gfRWcNAlLQuzU2Oc=
Date: Mon, 3 Mar 2014 20:07:36 +0100
From: Gerhard Sittig <gsi@denx.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] clk: CCF clock primitives + custom IO accessors
Message-ID: <20140303190736.GU3327@book.gsilab.sittig.org>
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140302202940.GQ3327@book.gsilab.sittig.org>
 <19206d89-cd0d-4fea-9170-3fd0a8482bf5@VA3EHSMHS045.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <19206d89-cd0d-4fea-9170-3fd0a8482bf5@VA3EHSMHS045.ehs.local>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 09:35 -0800, Sören Brinkmann wrote:
> 
> It would be nice if we could use the logic provided in the mux, div etc
> primitives independently of how the HW is accessed and what is
> necessary to shift and mask those register values around, right? I
> mean, at then end we want to model a clk-(div|mux) and not a
> clk-(div|mux) which has only a single, memory-mapped control register,
> that does not overlap with other things, ...

Did you lookup the ll_ops discussion in the thread that
originated from
http://article.gmane.org/gmane.linux.ports.arm.kernel/289895 and
did you see the outlined logic in
http://article.gmane.org/gmane.linux.ports.arm.omap/109233 and
http://article.gmane.org/gmane.linux.ports.arm.omap/109381 ?

Support for regmap access instead of mere MMIO was one of the
things you could do with this approach.  You appear to be in the
situation where you need such an extension (or something similar,
but you really should look into the ll_ops thing).


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
