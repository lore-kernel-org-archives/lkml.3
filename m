Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbaLDVP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:15:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:6536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbaLDVPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:15:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="618815698"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Foley <pefoley2@pefoley.com>,
        Seth Jennings <sjennings@variantweb.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Yokoyama\, Caz" <caz.yokoyama@intel.com>,
        "Chandramouli\, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        "Dutt\, Sudeep" <sudeep.dutt@intel.com>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/mic/mpssd: fix compile error on BE platforms
References: <alpine.LNX.2.00.1411201148370.4454@pobox.suse.cz>
	<1417708875-32189-1-git-send-email-ddstreet@ieee.org>
Date: Thu, 04 Dec 2014 13:33:10 -0800
In-Reply-To: <1417708875-32189-1-git-send-email-ddstreet@ieee.org> (Dan
	Streetman's message of "Thu, 4 Dec 2014 09:01:15 -0700")
Message-ID: <m3tx1bt815.fsf@adixit-yct.ra.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04 2014 at 08:01:15 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> Change any use of htole* macro in static context to instead manually check
> for endianness and use __bswap_constant_* macro instead.
>
> The current glibc definitions of the htole* macros don't allow their use
> in a static context; on big endian systems the build fails with:

Instead of building Documentation/mic/mpssd for all architectures, I
have submitted a patch which would build it only for x86_64 since that
is the only place where it will ever be used. This would resolve this
and future builds breaks and also make this patch unnecessary. The
maintainers can decide to accept either or these patches, or even both.
