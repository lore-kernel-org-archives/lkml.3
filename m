Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbbA2BK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:10:56 -0500
Received: from tex.lwn.net ([70.33.254.29]:35862 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbbA2BKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:51 -0500
Date: Wed, 28 Jan 2015 14:57:41 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 6/7] [media] marvell-ccic: MMP_CAMERA never worked
Message-ID: <20150128145741.02812a8f@lwn.net>
In-Reply-To: <1422479867-3370921-7-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
	<1422479867-3370921-7-git-send-email-arnd@arndb.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 22:17:46 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> The mmp ccic driver uses a platform_data structure that has never
> existed in an upstream kernel and always fails to build:

This driver most assuredly did work on XO 1.75 machines, and the
platform_data structure does exist; it's the stuff added by Libin
afterward that apparently broke things.  Strange that it only came out now,
though, nearly two years later. Libin, any thoughts on this?

Meanwhile, it is clearly broken, and I don't have an immediate fix, so,

Acked-by: Jonathan Corbet <corbet@lwn.net>

(Though I would like a different patch subject, since the current one is
wrong).

I think the right thing to do, alas, might be to back out all of Libin's
changes.  They clearly are not being used by anybody and do not seem to be
getting any further development attention.  It would like to keep this
driver working for XO systems for a while yet...but I won't get to it
right away.

Thanks,

jon
