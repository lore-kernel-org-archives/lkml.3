Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3KUM4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:56:20 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42706 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:56:18 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] ARM: CCI : Fix implicit declaration of function error
To: Dave Martin <Dave.Martin@arm.com>,
        Majunath Goudar <csmanjuvijay@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Majunath Goudar <manju.goudar@lge.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, nataraja.km@lge.com
In-Reply-To: <20131017121227.GC2442@localhost.localdomain>
References: <20131017121227.GC2442@localhost.localdomain>
Date: Thu, 21 Nov 2013 12:56:14 +0000
Message-Id: <20131121125614.26955C40A2C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 13:12:28 +0100, Dave Martin <Dave.Martin@arm.com> wrote:
> On Mon, Oct 14, 2013 at 03:52:27PM +0530, Majunath Goudar wrote:
> > This patch adds a inline dummy implementations of_find_matching_node()
> > in "#ifdef CONFIG_OF" else part. Without this patch,build system can
> > lead to issues. This was discovered during randconfig testing,in which
> > ARM_CCI was enabled w/o CONFIG_OF being enabled,leading to the following error:
> 
> Without fetching config info from the DT, the CCI driver is not usable,
> so it makes no sense to build this driver without CONFIG_OF.

I agree here, and that is the big reason why I'm resistant to blanket
implementation of empty OF related functions. If those functions are
called, then most likely the code strongly depends on CONFIG_OF. Leaving
the blank ones out catches scenarios like this.

g.

