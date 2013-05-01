Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3EAQvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:51:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:2403 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3EAQvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:51:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,590,1363158000"; 
   d="scan'208";a="330756065"
From: Andi Kleen <andi@firstfloor.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
	<20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org>
Date: Wed, 01 May 2013 09:51:32 -0700
In-Reply-To: <20130501163404.GA6286@thunk.org> (Theodore Ts'o's message of
	"Wed, 1 May 2013 12:34:04 -0400")
Message-ID: <m21u9qve23.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:
>
> In fact, there is the question of whether we should be checking to see
> if the CPU stepping is one of the ones with the bug, and if so, to
> have Linux disable fast strings even if the BIOS didn't, instead of
> blindly enabling fast strings....

Crossing pages with different memory attributes shouldn't happen 
in normal operation. I wouldn't be too concerned about that one.

I would suggest to leave the bit alone. There may be valid
reasons on the system to either set or not set it, which the kernel
doesn't necessarily know.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
