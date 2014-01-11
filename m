Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaAKRCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 12:02:00 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34274 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262AbaAKRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 12:01:57 -0500
Date: Sat, 11 Jan 2014 17:01:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/28] drm/i2c: tda998x: check more I/O errors
Message-ID: <20140111170151.GO15937@n2100.arm.linux.org.uk>
References: <20140109115745.5f81523e@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109115745.5f81523e@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:57:45AM +0100, Jean-Francois Moine wrote:
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

This lacks a description detailing why this change is necessary.  While
I can see the sense in preventing a subsequent write succeeding after a
failed page register write, we still continue blindly on accessing the
device after a read or write fails.  For istance, how many calls to
reg_write() or reg_read() are checked for failure?

That said, the patch does not appear to create any detrimental effects,
so it gets a tested-by but *no* acked-by.  Please give it a better
description justifying this change for an acked-by.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
