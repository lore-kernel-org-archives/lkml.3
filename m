Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbbAWNf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:35:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:48274 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbAWNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:35:23 -0500
Message-ID: <54C24E14.60701@ahsoftware.de>
Date: Fri, 23 Jan 2015 14:35:16 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key
 after modules were installed
References: <54C23FE2.9030303@ahsoftware.de> <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <54C21361.1080500@suse.cz> <54C216D8.8040004@ahsoftware.de> <54C21F35.1040206@ahsoftware.de> <54C22891.6070506@suse.cz> <54C233FB.3080309@ahsoftware.de> <54C2367C.4000909@ahsoftware.de> <27402.1422017769@warthog.procyon.org.uk> <54C24C30.8030106@ahsoftware.de>
In-Reply-To: <54C24C30.8030106@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, either I type too fast or I think too slow, so here is another 
comment:

Am 23.01.2015 um 14:27 schrieb Alexander Holler:
> Am 23.01.2015 um 13:56 schrieb David Howells:
>
>> One thing that you have to be careful of with your patch is that if
>> you turn
>> it on during development, this will drain the entropy pool from which
>> you get
>> random numbers.
>
> Hmm, I wonder how often people are compiling kernels and how much one
> turn drains the entropy pool.
>
> I would suggest to just get better in coding (and reviewing before
> compile testing) in order to not having to build kernels that often. Or
> just use a different config for development. ;)
>
> My primary use case is just what Linus described in his keynote. I'm
> building and signing all my kernels whenever a new stable kernel
> appears, throwing away the keys away immediately afterwards.
>
> And the patch avoids that I have to type the rm, and, even more usefull,
> it makes sure I don't forget to delete the keys, which would make
> signing the modules useless for me (as my kernel build directories (and
> thus the private keys) are usually residing on the machine the kernel is
> deployed afterwards).

Besides that the keys are only deleted when modules_install is called. 
And that usually is only called if the kernels execution will be tested 
in real, which should offer enough time to fill the entropy pool. If the 
kernel and the modules are just build (and not installed), the keys will 
not be deleted.

Regards,

Alexander Holler
