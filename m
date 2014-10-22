Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaJVMyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:54:04 -0400
Received: from roy.gaast.net ([80.101.33.21]:57871 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049AbaJVMyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:54:02 -0400
Date: Wed, 22 Oct 2014 13:53:55 +0100
From: Wilmer van der Gaast <wilmer@gaast.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Machine crashes right *after* ~successful resume
Message-ID: <20141022125354.GA3832@gaast.net>
References: <543F049F.5090605@gaast.net>
 <CAE9FiQWDHq5esSt4UvE5AkHR-=XMvrzaNFwLg+0xKisTNOtcsQ@mail.gmail.com>
 <543F9182.9000004@gaast.net>
 <CAE9FiQVNZHTxpNCnn+YPtqjWrQjFmtTh06sbBawqFonMFwSZ-w@mail.gmail.com>
 <544033CF.3080104@gaast.net>
 <CAE9FiQW0x5uy_osjvVDOOMDaz2=2KL+TusQ8QqcHL5dWTPrK2w@mail.gmail.com>
 <5442FE58.5020700@gaast.net>
 <CAE9FiQWugqXZdZDhDyKofKRXH6EgVq6DJ0JphM6DZSdS5nMhbw@mail.gmail.com>
 <5446D2D8.2090203@gaast.net>
 <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQWjvZapL0u5QSwD3gYTXisKrCgRcUYWAcy8onUYbkLHTg@mail.gmail.com>
X-Operating-System: Linux 3.2.0-4-686-pae on a i686
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yinghai,

This looks more promising!

Yinghai Lu (yinghai@kernel.org) wrote:
> >
> > And then nothing, and it's hung. Looks the same to me (apart from the tsc
> > issues + hpet switch) as a successful resume:
> 
> then it stuck in pm_restore_console()?
> 
That seems to be the case yes:

[  106.661152] PM: ... nb fw_pm_notify+0x0/0x150 done
[  106.665939] PM: calling nb bsp_pm_callback+0x0/0x50
[  106.670814] PM: ... nb bsp_pm_callback+0x0/0x50 done
[  106.675775] pm_restore_console() before move

Then nothing, during the third resume.

http://gaast.net/~wilmer/.lkml/bad3.17-patched-console-restore.txt has
the full log.

(Some of your other debug lines in your patch don't seem to be logging
anything during my repro BTW.)


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
