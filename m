Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3FQK37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab3FQK34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:29:56 -0400
Date: Mon, 17 Jun 2013 11:29:44 +0100
From: Joe Thornber <thornber@redhat.com>
To: OS Engineering <osengineering@stec-inc.com>
Cc: "koverstreet@google.com" <koverstreet@google.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: Performance Comparison among EnhanceIO, bcache and dm-cache.
Message-ID: <20130617102943.GA11121@debian>
Mail-Followup-To: OS Engineering <osengineering@stec-inc.com>,
	"koverstreet@google.com" <koverstreet@google.com>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Padmini Balasubramaniyan <padminib@stec-inc.com>,
	Amit Phansalkar <aphansalkar@stec-inc.com>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 03:05:07PM +0000, OS Engineering wrote:

...

> Dm-cache commits on-disk metadata every time a REQ_SYNC or REQ_FUA
> bio is written. If no such requests are made then it commits
> metadata once every second. If power is lost, it may lose some
> recent writes.

Not true (though it is true for thinp, which may be where you got this
idea?).  For caching we have to commit whenever data is moved about,
otherwise a crash could result in us reading data that is not just out
of date (acceptable for some), but used to belong to a totally
different part of the device (always unacceptable).

- Joe
