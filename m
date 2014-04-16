Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaDPKaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:30:12 -0400
Received: from mano-163-49-shared.jabatus.fr ([109.234.163.49]:40219 "EHLO
	mano-163-49-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbaDPKaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:30:07 -0400
X-Greylist: delayed 74095 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 06:30:07 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 0499AA643B9A.AFE41
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534E5A10.9040706@manux.info>
Date: Wed, 16 Apr 2014 12:23:12 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][3/11][MANUX] Kernel compatibility : syscall numbers
References: <534D375B.9070806@manux.info> <534E2B4B.30801@ladisch.de>
In-Reply-To: <534E2B4B.30801@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/04/2014 09:03, Clemens Ladisch a écrit :
> Emmanuel Colbus wrote:
>> I have a question regarding vector 0x80.
>>
>> As I mentionned earlier, my OS's internals are very different from
>> Linux's, thus I have had a need for a few new syscalls. Since I wanted
>> to avoid any collision with Linux
> 
> ... you could just use another vector, such as 0x81.
> 
>> but I also wanted to keep the ability to put the syscall table in
>> a single 4096-byte page on 64-bit computers (on which I hope to run
>> one day), I chose to start taking syscall number 511, and to progress
>> downwards - currently, I'm using numbers 511 through 501 included
> 
> These implementation details do not need to show up in the interface:
> 
> int syscall_0x81(int nr, ...)
> {
>     if (nr in range)
>         return table[511 - nr](...);
> }
> 
> 
> Regards,
> Clemens
> 

This would stop working as soon as I implemented any syscall/sysret or
sysenter/sysexit-like thing, as this technique has no notion of a
syscall vector.

Regards,

Emmanuel
