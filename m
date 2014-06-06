Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaFFX2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:28:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32967 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaFFX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:28:14 -0400
Date: Fri, 06 Jun 2014 16:28:12 -0700 (PDT)
Message-Id: <20140606.162812.1842868056512941704.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: mISDN: dsp_cmx.c: Cleaning up a define that is
 no longer available
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402097131-10954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402097131-10954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Jun 2014 16:28:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat,  7 Jun 2014 01:25:30 +0200

> Removes an ifdef that is no longer available,
> and that would cause a compile error if it was activated.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This indentation looks wrong, and if you scan up you'll see why.

A different set of CPP guards create the openning curly brace(s):

	/* PROCESS DATA (two members) */
#ifdef CMX_CONF_DEBUG
	if (0) {
#else
		if (members == 2) {
#endif

This is crazy, and deleting only the DSP_NEVER_DEFINED part makes it
even more confusing because less sophisticated code analysis tools and
editing mode will think that the braces are unbalanced now.

I'm not applying this, it makes things worse not better, sorry.
