Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaHZACF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:02:05 -0400
Received: from qmta08.westchester.pa.mail.comcast.net ([76.96.62.80]:38280
	"EHLO qmta08.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbaHZACD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:02:03 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2014 20:02:03 EDT
Message-ID: <53FBCD09.1050003@gentoo.org>
Date: Mon, 25 Aug 2014 19:55:53 -0400
From: Joshua Kinard <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, Max Filippov <jcmvbkbc@gmail.com>
CC: linux-xtensa@linux-xtensa.org, Chris Zankel <chris@zankel.net>,
        Marc Gauthier <marc@cadence.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Steven Hill <Steven.Hill@imgtec.com>
Subject: Re: [PATCH v4 0/2] mm/highmem: make kmap cache coloring aware
References: <1406941899-19932-1-git-send-email-jcmvbkbc@gmail.com> <20140825171600.GH25892@linux-mips.org>
In-Reply-To: <20140825171600.GH25892@linux-mips.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2014 13:16, Ralf Baechle wrote:
> On Sat, Aug 02, 2014 at 05:11:37AM +0400, Max Filippov wrote:
> 
>> this series adds mapping color control to the generic kmap code, allowing
>> architectures with aliasing VIPT cache to use high memory. There's also
>> use example of this new interface by xtensa.
> 
> I haven't actually ported this to MIPS but it certainly appears to be
> the right framework to get highmem aliases handled on MIPS, too.
> 
> Though I still consider increasing PAGE_SIZE to 16k the preferable
> solution because it will entirly do away with cache aliases.

Won't setting PAGE_SIZE to 16k break some existing userlands (o32)?  I use a
4k PAGE_SIZE because the last few times I've tried 16k or 64k, init won't
load (SIGSEGVs or such, which panicks the kernel).

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And
our lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
