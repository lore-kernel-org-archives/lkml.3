Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3HRVKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:10:05 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:36058 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab3HRVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:10:03 -0400
Date: Mon, 19 Aug 2013 00:09:52 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Kamal Mostafa <kamal@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 076/133] ARM: update FIQ support for relocation of vectors
Message-ID: <20130818210952.GI3067@blackmetal.musicnaut.iki.fi>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
 <1376692475-28413-77-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376692475-28413-77-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:33:38PM -0700, Kamal Mostafa wrote:
> 3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> commit e39e3f3ebfef03450cf7bfa7a974a8c61f7980c8 upstream.
> 
> FIQ should no longer copy the FIQ code into the user visible vector
> page.  Instead, it should use the hidden page.  This change makes
> that happen.

FYI, this patch introduced regression (kernel crash) at least on Amstrad
E1 board (where FIQ is used for the keyboard). See the following thread:
http://marc.info/?t=137583169900003&r=1&w=2

So any stable kernels where this patch was added should also take:

	commit 2ba85e7af4c639d933c9a87a6d7363f2983d5ada
	Author: Russell King <rmk+kernel@arm.linux.org.uk>
	Date:   Thu Aug 8 11:51:21 2013 +0100

	ARM: Fix FIQ code on VIVT CPUs

That patch fixes the regression.

A.
