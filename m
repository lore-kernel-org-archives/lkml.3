Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaENPw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:52:58 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:47874 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaENPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:52:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140514112347.3f630565@endymion.delvare>
References: <20140514112347.3f630565@endymion.delvare>
From: Mike Waychison <mikew@google.com>
Date: Wed, 14 May 2014 08:52:36 -0700
Message-ID: <CAGTjWtAjfzr=7K_0k=MKRXTxiWDSGOOYrzY0tA-7z=BpLVM-gA@mail.gmail.com>
Subject: Re: Purpose of dmi-sysfs kernel module
To: Jean Delvare <jdelvare@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, May 14, 2014 at 2:23 AM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Mike, Bjorn,
>
> Sorry for joining the party a little late but I am just discovering the
> dmi-sysfs kernel module. I have to admit that I am very curious about
> why it was needed. What does it let you achieve that you couldn't
> already do with dmidecode [1]?

The downside to using dmidecode is that (at least at the time), it
involved requiring giving access to /dev/mem to the binary so that it
could grub around in raw memory looking for the records.  dmi-sysfs
provides an alternative that allows for kernel-parsed entries to be
exposed to userland without having to expose /dev/mem and raw IO which
is insecure.

> I read on LWM [2] that you were mostly interested in type 15 records,
> to gain access to the System Event Log information. Well, "dmidecode -t
> 15" does exactly that. It may be a bit late now but if anything is
> missing from dmidecode, I would rather add it there than implement a
> separate solution.
>
> [1] http://www.nongnu.org/dmidecode/
> [2] http://lwn.net/Articles/429427/
>
> Thanks,
> --
> Jean Delvare
> SUSE L3 Support
