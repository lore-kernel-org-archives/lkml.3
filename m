Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3FNWB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:01:57 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36635 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3FNWBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:01:47 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] dtc: ensure #line directives don't consume data from the next line
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org,
        Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, jdl@jdl.com,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <51AF6C3A.5020609@wwwdotorg.org>
References: <1370273816-19411-1-git-send-email-swarren@wwwdotorg.org> <51AF6C3A.5020609@wwwdotorg.org>
Date: Fri, 14 Jun 2013 23:01:35 +0100
Message-Id: <20130614220135.0D0D63E0A56@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jun 2013 10:50:02 -0600, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/03/2013 09:36 AM, Stephen Warren wrote:
> > From: Stephen Warren <swarren@nvidia.com>
> > 
> > Previously, the #line parsing regex ended with ({WS}+[0-9]+)?. The {WS}
> > could match line-break characters. If the #line directive did not contain
> > the optional flags field at the end, this could cause any integer data on
> > the next line to be consumed as part of the #line directive parsing. This
> > could cause syntax errors (i.e. #line parsing consuming the leading 0
> > from a hex literal 0x1234, leaving x1234 to be parsed as cell data,
> > which is a syntax error), or invalid compilation results (i.e. simply
> > consuming literal 1234 as part of the #line processing, thus removing it
> > from the cell data).
> > 
> > Fix this by replacing {WS} with [ \t] so that it can't match line-breaks.
> > 
> > Convert all instances of {WS}, even though the other instances should be
> > irrelevant for any well-formed #line directive. This is done for
> > consistency and ultimate safety.
> > 
> > This is a port of upstream dtc commit a1ee6f0 (with same subject) to the
> > kernel's copy of dtc.
> 
> Rob, Grant, does this look OK to apply for v3.10-rc*?

The fix is in mainline now. Please check to make sure it is working for you.

g.


-- 
email sent from notmuch.vim plugin
