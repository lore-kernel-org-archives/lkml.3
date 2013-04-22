Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3DVLcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:32:36 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:47705 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3DVLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:32:34 -0400
Subject: Re: Cannot add new efi boot entry
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Jiri Slaby <jslaby@suse.cz>, matthew.garrett@nebula.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <517519E3.2030409@console-pimps.org>
References: <516B1ED3.9040900@suse.cz>
	 <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com>
	 <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org>
	 <51703664.40003@suse.cz> <5172466B.9080105@suse.cz>
	 <517519E3.2030409@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Apr 2013 19:31:17 +0800
Message-ID: <1366630277.23707.132.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2013-04-22 於 12:07 +0100，Matt Fleming 提到：
> On 20/04/13 08:40, Jiri Slaby wrote:
> > On 04/18/2013 08:07 PM, Jiri Slaby wrote:
> >> On 04/17/2013 04:51 PM, Matt Fleming wrote:
> >>> On 17/04/13 15:29, Jiri Slaby wrote:
> >>>> On 04/16/2013 12:11 PM, Matt Fleming wrote:
> >>>>> On 16/04/13 10:56, joeyli wrote:
> >>>>>> I think I just got the same situation on my side with Acer machine. I am
> >>>>>> trying Matthew's new patchset hope can avoid this situation:
> >>>>>>
> >>>>>> https://lkml.org/lkml/2013/4/15/473
> >>>>>
> >>>>> Please do let us know whether the patches work for you.
> >>>>
> >>>> Hmm, where did efi_query_variable_store in 3/3 come from?
> >>>
> >>> It's in a patch on the 'urgent' branch at,
> >>>
> >>>     git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> >>
> >> The 3 patches plus that one work for me.
> > 
> > Actually they don't :(:
> > open("/sys/firmware/efi/vars/new_var", O_WRONLY) = 3
> > write(3,
> > "B\0o\0o\0t\0000\0000\0001\0003\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
> > 2084) = -1 ENOSPC (No space left on device)
> > close(3)                                = 0
> 
> Thanks for testing Jiri.
> 
> You can disable the EFI storage checks in -rc8 by using the
> efi_no_storage_paranoia kernel parameter, but it's only recommended to
> do that if you machine ends up in these kinds of situations where
> garbage collection isn't be initiated, or your machine ships with > 50%

Does garbage collection only trigger by UEFI BIOS when system reboot? or
garbage collection also triggered at run time?

There have a problem is if we delete boot entry when the flash space
tight(maybe 99%, just remaining_size < max_size), then we can not create
new boot entry unless we reboot system for trigger garbage collection.
But we already lost available boot entry.

> of the variable store in use from the factory.
> 
> Matthew, what kind of info do you need from Jiri to improve the storage
> limit algorithm?
> 

Thanks a lot!
Joey Lee


