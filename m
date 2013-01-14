Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3ANBmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 20:42:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab3ANBml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 20:42:41 -0500
Date: Mon, 14 Jan 2013 01:42:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] regulator-core: update all enable GPIO state in
	_enable/disable
Message-ID: <20130114014239.GA29909@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com> <20130113224220.GE5041@opensource.wolfsonmicro.com> <A874F61F95741C4A9BA573A70FE3998F69E12A0D@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E12A0D@DQHE02.ent.ti.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 11:35:03PM +0000, Kim, Milo wrote:

> Thanks for your opinion.
> My understanding is 'shared' enable pin means regulators are enabled/disabled
> at the same time.
> Any other case is possible?

So, clearly that's going to be the behaviour at the system level but the
consumers aren't going to know that.  If the consumer supports some of
the supplies being enabled and disabled separately then it will rely on
the regulator core reference counting to keep the supply enabled if
there are other reasons to do so.  This is how things would work if both
supplies came from the same regulator so I'd expect us to preserve the
same behaviour.
