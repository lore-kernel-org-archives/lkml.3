Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaBWXnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 18:43:43 -0500
Received: from top.free-electrons.com ([176.31.233.9]:48862 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbaBWXnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 18:43:42 -0500
Date: Sun, 23 Feb 2014 20:41:51 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] clk: respect the clock dependencies in of_clk_init
Message-ID: <20140223234150.GA5343@localhost>
References: <1392054179-28830-1-git-send-email-gregory.clement@free-electrons.com>
 <530A420B.5050207@gmail.com>
 <20140223212040.22529.18650@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140223212040.22529.18650@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz, Mike:

On Sun, Feb 23, 2014 at 01:20:40PM -0800, Mike Turquette wrote:
> Quoting Tomasz Figa (2014-02-23 10:46:35)
> > On 10.02.2014 18:42, Gregory CLEMENT wrote:
> > > Until now the clock providers were initialized in the order found in
> > > the device tree. This led to have the dependencies between the clocks
> > > not respected: children clocks could be initialized before their
> > > parent clocks.
> > >
> > > Instead of forcing each platform to manage its own initialization order,
> > > this patch adds this work inside the framework itself.
> > >
> > > Using the data of the device tree the of_clk_init function now delayed
> > > the initialization of a clock provider if its parent provider was not
> > > ready yet.
> > 
> > In general this is really great. It's a first step towards sorting out 
> > dependencies between clock providers correctly. I have some comments 
> > inline, though.
> 
> Just to add in here, I think the approach is good but agree with Tomasz'
> review comments.
> 

I'm wondering if any of you has followed the discussion that Greg,
Emilio and I had about the need of this change.

If so, can you point out *why* we need to sort out registration
dependency?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
