Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3JAFEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 01:04:14 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62122 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3JAFEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 01:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130928221513.GA20640@htj.dyndns.org>
References: <1380404984-31858-1-git-send-email-tj@kernel.org> <20130928221513.GA20640@htj.dyndns.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Sep 2013 23:03:50 -0600
Message-ID: <CAErSpo5gNQF+B1HngZzxEP3cST_s83=usK27UXmO8G0zXKsbvQ@mail.gmail.com>
Subject: Re: [PATCHSET] sysfs: use seq_file and unify regular and bin file handling
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 4:15 PM, Tejun Heo <tj@kernel.org> wrote:
> Hey, again.
>
> On Sat, Sep 28, 2013 at 05:49:30PM -0400, Tejun Heo wrote:
>>  0001-sysfs-remove-unused-sysfs_buffer-pos.patch
>>  0002-sysfs-remove-sysfs_buffer-needs_read_fill.patch
>>  0003-sysfs-remove-sysfs_buffer-ops.patch
>>  0004-sysfs-add-sysfs_open_file_mutex.patch
>>  0005-sysfs-rename-sysfs_buffer-to-sysfs_open_file.patch
>>  0006-sysfs-add-sysfs_open_file-sd-and-file.patch
>>  0007-sysfs-use-transient-write-buffer.patch
>>  0008-sysfs-use-seq_file-when-reading-regular-files.patch
>>  0009-sysfs-prepare-llseek-path-for-unified-regular-bin-fi.patch
>>  0010-sysfs-prepare-path-write-for-unified-regular-bin-fil.patch
>>  0011-sysfs-prepare-read-path-for-unified-regular-bin-file.patch
>>  0012-sysfs-copy-bin-mmap-support-from-fs-sysfs-bin.c-to-f.patch
>>  0013-sysfs-prepare-open-path-for-unified-regular-bin-file.patch
>>  0014-sysfs-merge-regular-and-bin-file-handling.patch
>
> On the second thought, 0011 seems too dangerous, especially for pci IO
> BAR regions.  Grumble, looks like I'll have to break out the bin read
> path.  Please ignore patches >= 0009.  I'll update them and repost.

I don't pretend to understand sysfs or the issue you tripped over with
PCI I/O BAR regions.  But we had a long discussion about those files
[1] last spring, and I'm pretty convinced that it was a mistake to add
them in their current form, and I would support an attempt to rework
them.  We had some ideas about how to do that, but I think everybody
lost interest before anything happened.

Bjorn

[1] http://lkml.kernel.org/r/20130316213519.2974.38954.stgit@amt.stowe
