Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaENPtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:49:18 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56887 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaENPtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:49:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
To: Michael Stickel <ms@mycable.de>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Guenter Roeck <linux@roeck-us.net>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <53735D88.5090108@mycable.de>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
	<53735D88.5090108@mycable.de>
Date: Wed, 14 May 2014 16:49:07 +0100
Message-Id: <20140514154907.BC65DC40BD2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 14:11:52 +0200, Michael Stickel <ms@mycable.de> wrote:
> Hi Grant,
> 
> Am 14.05.2014 12:08, schrieb Grant Likely:
> > More generally I am concerned about whether or not overlays
> > will introduce corner cases that can never be handled correctly,
> > particularly in how multiple overlays will get handled. I want to see
> > very clear rules on what happens when multiple overlays are applied, and
> > then removed again. Is it possible to remove overlays out of order? If
> > so, what are the conditions that would not be allowed?
> 
> Yes, it is possible that an overlay depends on another.
> 
> The problem is not, that an overlay is removed other overlays depend on,
> but that nodes of an overlay may depend on the to-be-removed overlay and
> the resulting devicetree can become inconsistent.

So what should the rule be then? It sounds to me that it should be a
hard and fast rule for overlays to always be removed in-order. If two
overlays are applied, and the first one needs to be removed again, then
that forces a removal of the second. The code needs to enforce it too.

The question can be revisited if someone can find a way to validate
overlays do not conflict.

g.

