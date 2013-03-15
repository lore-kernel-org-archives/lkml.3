Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3CORBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:01:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36307 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab3CORBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:01:05 -0400
Date: Fri, 15 Mar 2013 16:59:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bill Huang <bilhuang@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in
	clk_prepare_enable/clk_disable_unprepare
Message-ID: <20130315165947.GL4977@n2100.arm.linux.org.uk>
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com> <20130312134032.GU4977@n2100.arm.linux.org.uk> <1363139273.21694.11.camel@bilhuang-vm1> <514003B6.8020904@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514003B6.8020904@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:42:30PM -0600, Stephen Warren wrote:
> I believe the point Russell is making is not that the idea behind this
> patch is wrong, but simply that the function where you put the hooks is
> wrong. The hooks should at least be in clk_enable/clk_disable and not

Indeed, remembering that clk_enable/clk_disable can be called from
atomic contexts.

If the hook needs to be non-atomic (iow, it can schedule) then it can't
go into clk_enable/clk_disable, and must go into clk_prepare/clk_unprepare,
which is the schedulable half of that API.
