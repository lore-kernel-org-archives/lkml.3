Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaDOPfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:35:10 -0400
Received: from mano-163-24-shared.jabatus.fr ([109.234.163.24]:39873 "EHLO
	mano-163-24-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbaDOPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:35:08 -0400
X-Greylist: delayed 6295 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 11:35:08 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: DAC5391A29AB.A3A8D
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D5119.8050701@manux.info>
Date: Tue, 15 Apr 2014 17:32:41 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
References: <534D3762.4010905@manux.info> <20140415160626.322e24ee@alan.etchedpixels.co.uk>
In-Reply-To: <20140415160626.322e24ee@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 17:06, One Thousand Gnomes a écrit :
>> In order to associate devices to their files, the Linux kernel uses
>> their major and minor numbers. However, mine doesn't; instead, I've
>> attributed myself a single group of values (major=0, minor=0, for both
>> character-mode and block-mode special files), with the meaning (for the
>> userspace) "you cannot identify the content of this file based on its
>> major and minor numbers".
> 
> If you are using the Linux ABI then you'll hit cases (in particular tty
> cases) where the ABI/API knows about major/minor numbers. 

Well, in fact, my kernel *can* handle major and minor numbers. That is,
if you tell it "mknod /dev/efjkb c 8 6" , you'll actually get a device
file with major/minor numbers 8/6. But then, the kernel simply
disregards these values and waits for userspace to specify it what this
device means. So it's completely possible to emulate Linux's behaviour
with it.

> In addition the
> standards and common sense together pretty much imply that you need each
> device to at least have a unique identifier.
>

Why is it? I mean, as far as userspace is concerned, they do have a
unique identifier : their name. How would it be problematic that the
software is unable to confirm that /dev/null is actually connected to
the usual /dev/null kernel driver? I mean, it's supposed to trust the OS
and its admin to have done their job properly, not second-guess them!

(My idea behind this is to allow lying, for example by allowing the
sysadmin to fake the content of, say, /dev/random, to an application he
wants to test, or even deliberately sabotage. So, in my OS's logic,
there's nothing wrong with emulating Linux's major/minor device
identifiers, but of course, their reliability will be in the sysadmin's
hands, so I thought I could simply make this clear by using explicitely
unreliable identifiers.)

> Finally you need major/minor numbers to NFS serve to a diskless client.

Not a problem, but of course, the distant client will have the ability
to connect anything it wants to any device it wants.

> 
> Most Linux device numbering beyond that is basically dynamic so it
> probably does't matter that much for things you concoct - providing in
> som cases your /proc table of major numbers is right.
> 

Ah... Uhhh... I've not implemented any such table, so I guess it's
currently not. Whoops...

Emmanuel
