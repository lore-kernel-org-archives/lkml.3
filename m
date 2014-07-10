Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaGJTMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:12:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41025 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaGJTMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:12:32 -0400
Date: Thu, 10 Jul 2014 21:12:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
Message-ID: <20140710191224.GF5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
 <20140710164151.GA5603@pd.tnic>
 <CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
 <20140710184416.GE5603@pd.tnic>
 <CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:57:06AM -0700, Tony Luck wrote:
> You don't know if the bank is shared or not. If it is not shared, then
> the above code might skip reading the bank because some other cpu is
> busy reading that bank number - and seeing its own private bank.

Grrr, I see what you mean.

Hmm, can we serialize machine_check_poll per CPU in a cheaper way?
Disabling interrupts around the reads is certainly fine but still too
heavy-handed IMO.

I'll think about it more tomorrow - my brain is twisted enough for
today. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
