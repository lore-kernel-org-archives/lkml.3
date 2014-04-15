Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaDOU6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:58:16 -0400
Received: from mano-163-54-shared.jabatus.fr ([109.234.163.54]:44178 "EHLO
	mano-163-54-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784AbaDOU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:58:14 -0400
X-Greylist: delayed 25091 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 16:58:14 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: EDDE0989060E.A30AF
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D9D63.2050608@manux.info>
Date: Tue, 15 Apr 2014 22:58:11 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
References: <534D3762.4010905@manux.info> <20140415160626.322e24ee@alan.etchedpixels.co.uk> <534D5119.8050701@manux.info> <20140415201914.GK4456@thunk.org>
In-Reply-To: <20140415201914.GK4456@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/04/2014 22:19, Theodore Ts'o a écrit :
> On Tue, Apr 15, 2014 at 05:32:41PM +0200, Emmanuel Colbus wrote:
>>> In addition the
>>> standards and common sense together pretty much imply that you need each
>>> device to at least have a unique identifier.
>>>
>>
>> Why is it? I mean, as far as userspace is concerned, they do have a
>> unique identifier : their name. How would it be problematic that the
>> software is unable to confirm that /dev/null is actually connected to
>> the usual /dev/null kernel driver? I mean, it's supposed to trust the OS
>> and its admin to have done their job properly, not second-guess them!
> 
> Backup programs will very often assume that if after two files, if
> stat(2)'ed, have the same st_ino and st_dev (which is a major/minor
> pair), then they are both hard links to the same underlying files.
> 
> There are also programs that will relying on st_dev for the purpose of
> honoring find -xdev, and there are also programs that may try to do
> intelligent things by assuming that st_dev and st_ino togehter will
> uniquely name the same content.  This gets tricky for remote file
> systems to get right, but file systems that don't at least try to get
> this right can end up triggering some very hard to debug userspace
> bugs.  Transarc's Andrew File System (AFS) would occasionally break
> this property, back in the late 1990's, and it was the cause of Much
> Hilarity (except on the part of the programmers who had to figure out
> why certain programs were stuck looping forever while trying to
> analyze a long AFS pathname...)

Yes, in fact, I do respect the unicity of the st_dev field, so all these
assumptions work. The only thing I'm doing is violating the assumption
that, if a file has a certain major and minor numbers according to its
st_dev field, then there is a special block file in /dev that has the
same major and minor numbers and that corresponds to the storage
peripheral where this file is stored.

Emmanuel
