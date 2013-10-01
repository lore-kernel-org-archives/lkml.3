Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3JAOXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:23:50 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:42219 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3JAOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:23:48 -0400
Date: Tue, 1 Oct 2013 10:23:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCHSET] sysfs: use seq_file and unify regular and bin file
 handling
Message-ID: <20131001142344.GA2736@htj.dyndns.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org>
 <20130928221513.GA20640@htj.dyndns.org>
 <CAErSpo5gNQF+B1HngZzxEP3cST_s83=usK27UXmO8G0zXKsbvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5gNQF+B1HngZzxEP3cST_s83=usK27UXmO8G0zXKsbvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 30, 2013 at 11:03:50PM -0600, Bjorn Helgaas wrote:
> I don't pretend to understand sysfs or the issue you tripped over with
> PCI I/O BAR regions.  But we had a long discussion about those files

The issue is rather simple.  Let's say I do "dd if=SOME_IO_BAR skip=12
bs=4 count=1", it should result in exactly 4 byte read from the ioport
at BAR + 12 as io reads may have side effects; however, seq_file
breaks that with buffering.  Pretty similar to using stdio on ioports.

> [1] last spring, and I'm pretty convinced that it was a mistake to add
> them in their current form, and I would support an attempt to rework
> them.  We had some ideas about how to do that, but I think everybody
> lost interest before anything happened.

Yeah, I was pretty weirded out after finding out that the BARs are
directly accessible through sysfs.  People run all sorts of scripts
over the sysfs hierarchy after all.  That said, I don't think sysfs
can simply pull out bin file support at this point.  I'll keep the
code path separate so that it can be easily separated out if we don't
need it later.

Thanks!

-- 
tejun
