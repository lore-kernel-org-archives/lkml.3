Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaE0MsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:48:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59920 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaE0MsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:48:02 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 2/2] of: Stop naming platform_device using dcr
 address
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4587381.5n3eMGkKaq@wuerfel>
References: <1400801769-4506-1-git-send-email-grant.likely@linaro.org>
	<1400801769-4506-3-git-send-email-grant.likely@linaro.org>
	<4587381.5n3eMGkKaq@wuerfel>
Date: Tue, 27 May 2014 13:47:49 +0100
Message-Id: <20140527124749.E196BC40FCB@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 16:07:08 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 23 May 2014 08:36:09 Grant Likely wrote:
> > There is now a way to ensure all platform devices get a unique name when
> > populated from the device tree, and the DCR_NATIVE code path is broken
> > anyway. PowerPC Cell (PS3) is the only platform that actually uses this
> > path.  Most likely nobody will notice if it is killed. Remove the code
> > and associated ugly #ifdef.
> > 
> > The user-visible impact of this patch is that any DCR device on Cell
> > will get a new name in the /sys/devices hierarchy.
> 
> Isn't this used on all ppc440+ as well?

Yes, but the 440 code path is broken so that it always uses the default
name instead. Therefore only Cell is affected.

g.
