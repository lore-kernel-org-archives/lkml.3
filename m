Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaETKDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:03:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39325 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaETKDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:03:14 -0400
Date: Tue, 20 May 2014 12:02:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Clear a useless global variable in mce.c
Message-ID: <20140520100252.GA16428@pd.tnic>
References: <1400328343-6483-1-git-send-email-slaoub@gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3280E51C@ORSMSX114.amr.corp.intel.com>
 <20140519181524.GC6311@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3280EA8A@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3280EA8A@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:06:38PM +0000, Luck, Tony wrote:
> I doubt there is any hope for recovery if not all processors show up
> ... things have to be already very broken for the machine check to be
> blocked.

Good, so this whole babble about the potential of a timeout and whatever
is all beside the point.

What we want to do is if any of the cores are stuck - monarch or not -
we want to panic the hell out of this box and not do anything further.
So only the tolerant check would need adjusting.

> I'm OK with it going - but as I said before I'd like to see mce_callin
> printed (so I can tell if just one cpu showed up, just the cpus from
> one socket, or some other significant number).

I don't think you want to do this unconditionally, do you? Rather maybe
mce_timed_out dumps the order variable before the box panics :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
