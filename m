Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIVPaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:30:01 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:52235 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaIVP37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:29:59 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] Fix nasty 32-bit overflow bug in buffer i/o code.
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com>
Date: Mon, 22 Sep 2014 16:29:56 +0100
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <55E81CB2-AB4B-41E2-88D5-B33F7D8B1DB8@cam.ac.uk>
References: <Pine.LNX.4.64.1409220042400.2595@hermes-1.csi.cam.ac.uk> <CA+55aFyYpe=oyF9yVqF3E6t4ZCpHAdnLj1g36FWUDZydW9mdgQ@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 22 Sep 2014, at 16:18, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sun, Sep 21, 2014 at 5:53 PM, Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>> 
>> This patch fixes this issue by type casting "index" to sector_t before
>> doing the left shift.
> 
> Ugh. Does the simpler patch to just pass in "block" work as well?

That doesn't work because nothing rounds down "block" to the first block in the page and init_page_buffers() requires "block" to be the first block in the page.

The shift right followed by shift left achieves the "rounding down" required.

You could do "block & ~(sector_t)(size - 1)" instead of "(sector_t)index << sizebits" if you prefer but not sure that is an improvement!

Best regards,

	Anton

>                    Linus
> <patch.diff>


-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

