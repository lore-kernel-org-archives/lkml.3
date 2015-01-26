Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbbAZUiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:38:09 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55729 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbAZUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:38:06 -0500
Date: Mon, 26 Jan 2015 20:37:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150126203751.GK26493@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201412041857.49341@pali>
 <CAL_JsqJ9i0jwaL1cyeomQG=bhhcnEgdGWYOqkcwidyk5xOUukg@mail.gmail.com>
 <201501262016.52079@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201501262016.52079@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 08:16:52PM +0100, Pali Rohár wrote:
> This patch will cause that decompressor store full ATAG structure into
> DT tree ("/atags"):

How about something a little more radical.

Rather than trying to squeeze various ATAGs into DT, why don't we add a
standard ATAG to contain the DT and pass that through into the kernel.
This is IMHO how we _should_ have done the ATAG compatibility from the
start.

That means we could get rid of most of the libfdt in the decompressor,
and instead resolve the differences in the kernel.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
