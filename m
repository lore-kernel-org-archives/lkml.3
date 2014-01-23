Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaAWRGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:06:46 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34631 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaAWRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:06:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140123150524.GH29955@cumulusnetworks.com>
References: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
	<20140123150524.GH29955@cumulusnetworks.com>
Date: Thu, 23 Jan 2014 17:06:43 +0000
X-Google-Sender-Auth: BxkQAuOxGh6Zd8J_IqhFTypSmoE
Message-ID: <CAOMwXhPXDhsGRWE1eUN6WWiMQkd1eSOaAD+N1nJTGDK3aHysDg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add at24 based EEPROMs to the eeprom_dev hardware class
From: Laszlo Papp <lpapp@kde.org>
To: Curt Brune <curt@cumulusnetworks.com>
Cc: Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>, wolfram@the-dreams.de,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 3:05 PM, Curt Brune <curt@cumulusnetworks.com> wrote:
> On Thu Jan 23 07:44, Laszlo Papp wrote:
>> On Wed, Jan 22, 2014 at 5:23 PM, Curt Brune <curt@cumulusnetworks.com> wrote:
>> > During device instantiation have the at24 driver add the new device to
>> > the eeprom_dev hardware class.  The functionality is enabled by
>> > CONFIG_EEPROM_CLASS.
> [snip]
>> >  static void __exit at24_exit(void)
>> >  {
>> >         i2c_del_driver(&at24_driver);
>> >  }
>> >  module_exit(at24_exit);
>>
>> Couldn't you use module_i2c_driver() instead of this?
>
> I'm not sure what you mean.
>
> Do you mean should the class registration/unregistration be put in
> module_i2c_driver()?  That would not work as not all i2c devices are
> eeproms.

When I was writing an i2c driver, I was taught to drop the init and
exit functions in favor of a module_i2c_driver() call. You could check
it with grep or lxr to see the details in other existing drivers. I
might be totally wrong as I have not much experience, but I thought I
would ask it either way... It does not hurt (at least not me). ;-)

>> >  MODULE_DESCRIPTION("Driver for most I2C EEPROMs");
>> >  MODULE_AUTHOR("David Brownell and Wolfram Sang");
>>
>> I would personally put your name in here if I were you, otherwise
>> David and Wolfram might get contacted by some people instead of you
>> (at least based on this).
>
> Hmmm.   I don't know.  I didn't change the driver very much, just
> added about 10 lines to a perfectly fine driver.  git-blame would
> point right at me for anything to do with this patch.

Fwiw, git will not help people using lxr for instance, and I would
personally mention them in the copyrights instead. You put this file
together, so IMO you are the author even if the copyrights is held by
other people. But I do not know the kernel rules, so I might be
totally wrong, so it is not a problem for me if you do not change it.
