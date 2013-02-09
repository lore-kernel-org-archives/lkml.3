Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3BIJ2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 04:28:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3BIJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 04:28:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
Date: Sat, 9 Feb 2013 09:28:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com> <20130208230127.5F3063E2C27@localhost> <5115F076.5000909@synopsys.com>
In-Reply-To: <5115F076.5000909@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302090928.43929.arnd@arndb.de>
X-Provags-ID: V02:K0:LvrCCogq1mCKW/vCTTH7BUAt4/99MeyXxR16YPj8H/N
 5lz2EoA8k7hxogj7JW+XugnRzqrF6QhAgExaVRdbb8zPy4/+pG
 KdOlD+QXRVDW66vG+WVMrpmWjLZ1gieSEkbV5gR/U5+2YpmgN/
 zR9TVjTH/MCKKUmHG2uzWvEaQK0mVHtSdWFoBmRaciuDaEML8I
 2kASwOee5fGqlOurfsJxRbIVuwBF6nHhheP7YIj48rObH+QGJ7
 wfCrpJZZlvf2Etra/AKwF9UHPjM//ER+VB2Zy6VBa0G5zzBzey
 KXyCkj85HwMqwOsmBU30U+4mNOh6JkxHTSN0DicCpLIhVQXP7z
 8VwcnOCYlE8vdzz2XsaM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2013, Vineet Gupta wrote:
> On Saturday 09 February 2013 04:31 AM, Grant Likely wrote:
> > On Fri, 11 Jan 2013 11:50:23 +0530, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> >> +- clock-frequency   : the input clock frequency for the UART
> >> +- baud                      : baud rate for UART
> > change 'baud' to 'current-speed'. There is already precedence for this
> > with other serial devices.
> 
> While I'm OK with this - I can only see of_serial.c following the rule :-)
> More importantly I'm not clear about the logistics of this fix. Obviously this has
> a bearing on DT files in arch/arc/boot/*. So are such changes (platform + driver)
> routed thru the subsystem tree or the arch tree or bits from both with
> bisectability not considered - which feels wrong. We have to also consider the
> fact that Greg has closed the tty/serial for 3.9. So while I have no objection to
> your comment, it seems that the it needs to wait till 3.9-rc1 - or is there an
> alternate way.

I'd consider this one a bug fix, so while Greg is not accepting any new
features for the serial tree, I think it should still get in that way
and should not be controversial as an add-on change.

	
	Arnd
