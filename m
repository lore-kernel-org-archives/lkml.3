Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3DYJB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:01:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60614 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab3DYJB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:01:57 -0400
Date: Thu, 25 Apr 2013 10:01:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3.8-stable] ARM: 7690/1: mm: fix CONFIG_LPAE typos
Message-ID: <20130425090147.GD12848@mudshark.cambridge.arm.com>
References: <004801ce33e4$0a2ffc00$1e8ff400$%choi@samsung.com>
 <000001ce418b$320597d0$9610c770$%choi@samsung.com>
 <1366878044.1349.19.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366878044.1349.19.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 09:20:44AM +0100, Paul Bolle wrote:
> On Thu, 2013-04-25 at 17:02 +0900, Jonghwan Choi wrote:
> > This patch looks like it should be in the 3.8-stable tree, should we apply
> > it?
> 
> That would be only the setup.c chunk. That fixes a typo introduced in
> v3.4 (see commit e5ab85800820edd907d3f43f285e1232f84d5a41
> ("ARM: 7382/1: mm: truncate memory banks to fit in 4GB space for classic
> MMU")). So, if that chunk is deemed appropriate for stable, you could
> consider the v3.4.y longterm tree too.

Even then, I don't think it's worth backporting this patch. membank->start
and membank->size are phys_addr_t, so with LPAE enabled, this check won't
trigger anyway. The #ifndef is just there for readability really (since the
printk message explicitly refers to 32-bit physical addresses).

So I wouldn't bother with this.

Will
