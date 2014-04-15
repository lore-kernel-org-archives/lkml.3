Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaDOPKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:10:37 -0400
Received: from mano-163-50-shared.jabatus.fr ([109.234.163.50]:38248 "EHLO
	mano-163-50-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbaDOPKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:10:36 -0400
X-Greylist: delayed 5123 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 11:10:36 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: AFA1191422FE.A0EAD
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D4BE9.5080805@manux.info>
Date: Tue, 15 Apr 2014 17:10:33 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][3/11][MANUX] Kernel compatibility : syscall numbers
References: <534D375B.9070806@manux.info> <20140415160213.490439ea@alan.etchedpixels.co.uk>
In-Reply-To: <20140415160213.490439ea@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 17:02, One Thousand Gnomes a écrit :
> On Tue, 15 Apr 2014 15:42:51 +0200
> Emmanuel Colbus <ecolbus@manux.info> wrote:
> 
>> Continuing the discussion regarding syscalls, I have a question
>> regarding vector 0x80.
>>
>> As I mentionned earlier, my OS's internals are very different from
>> Linux's, thus I have had a need for a few new syscalls. Since I wanted
>> to avoid any collision with Linux, but I also wanted to keep the
>> ability to put the syscall table in a single 4096-byte page on 64-bit
>> computers (on which I hope to run one day), I chose to start taking
>> syscall number 511, and to progress downwards - currently, I'm using
>> numbers 511 through 501 included (with a hole at 503, but I'll likely
>> fill it again in the future).
>>
>> Is this okay for you? And in this case, if this isn't asking too much,
>> could you avoid using them for now, to avoid any conflict?
> 
> I don't see why the question arises. Your non Linux ABI binaries will be
> the ones to use such calls. They can have a different ELF header to Linux
> binaries. Linux then won't even try and run them by mistake. At that
> point your worst case is Linux calls eventually collide with your own and
> you have two tables according to ABI.

Hmmm... I see your point... Currently, I simply use the Linux ELF
header, and I hadn't even thought about using a different one. Indeed,
using a different header seems like a good solution.

OK, unless a better idea arises, I think I'll use this solution.

Thanks!

Emmanuel

