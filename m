Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbaF3Tt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:49:56 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:63141 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaF3Ttz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:49:55 -0400
Date: Mon, 30 Jun 2014 21:49:49 +0200
From: Rabin Vincent <rabin@rab.in>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 4/5] clk: per-user clock accounting for debug
Message-ID: <20140630194949.GB5167@dator>
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
 <1403855872-14749-5-git-send-email-tomeu.vizoso@collabora.com>
 <53ADF3C8.2060702@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ADF3C8.2060702@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:44:24PM -0600, Stephen Warren wrote:
> On 06/27/2014 01:57 AM, Tomeu Vizoso wrote:
> >  struct clk {
> > -	struct clk_core clk;
> > +	struct clk_core	*core;
> > +	unsigned int	enable_count;
> > +	const char	*dev_id;
> > +	const char	*con_id;
> 
> Why not just store the "struct device *" there instead of pulling the
> name out of it, so ...

Probably because not all of the [of_]clk_get[_sys]() variants supply a
struct device *.
