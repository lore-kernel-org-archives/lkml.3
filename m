Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaFZSps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:45:48 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:54992 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbaFZSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:45:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIQAPpprFNXQz8N/2dsb2JhbABagw2CSYEAqAEBAQEBAQEFAW2YewICAYEMF3WEAwEBBAE6HCMFCwgDGC45HgYTiDoMAcI1F4VkiRwHhEMBBI96il4BizqIO4NEOw
Date: Thu, 26 Jun 2014 20:44:03 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bob Copeland <me@bobcopeland.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] FS/OMFS: block number sanity check during
 fill_super operation
Message-Id: <20140626204403.d4fadfadbfbba95a319b41f4@skynet.be>
In-Reply-To: <CA+55aFw2wVG7e2BLUt2oPeeo-zwZTavGHkD1oGSpyerMBfqTpw@mail.gmail.com>
References: <1403802228-8385-1-git-send-email-fabf@skynet.be>
	<CA+55aFwMNDegPgCD6AAKUUA-YCvViTp2nbwNkVojErrDkuFeUA@mail.gmail.com>
	<20140626202636.7b601260c02ecc45c3c87316@skynet.be>
	<CA+55aFw2wVG7e2BLUt2oPeeo-zwZTavGHkD1oGSpyerMBfqTpw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 11:35:57 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Jun 26, 2014 11:28 AM, "Fabian Frederick" <fabf@skynet.be> wrote:
> >
> >    Sorry but I don't see a problem with 2^31 value.
> 
> It's not really 2^31.
> 
> It's *negative* 2^31.
> 
> 1 is "int", so it's a signed number. With the shift it ends up being a
> signed number with the high bit set. That's just a bad bad idea.
> 
> Now, it just so happens that if you always compare it with unsigned
> numbers, C promotion rules will end up promoting it to unsigned and it
> happens to *work*, but that is more luck than design.
> 
> So I'd suggest using 0x80000000 (which is unsigned) or use (1ul<<31) or
> similar explicit C typing.

Ok, I understand now. Thanks a lot for taking the time to explain Linus.
It really means a lot to me.

Fabian
> 
>      Linus
