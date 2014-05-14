Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaENTXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:23:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaENTXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:23:51 -0400
Date: Wed, 14 May 2014 21:23:47 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Purpose of dmi-sysfs kernel module
Message-ID: <20140514212347.083a57f9@endymion.delvare>
In-Reply-To: <CAGTjWtAjfzr=7K_0k=MKRXTxiWDSGOOYrzY0tA-7z=BpLVM-gA@mail.gmail.com>
References: <20140514112347.3f630565@endymion.delvare>
	<CAGTjWtAjfzr=7K_0k=MKRXTxiWDSGOOYrzY0tA-7z=BpLVM-gA@mail.gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, 14 May 2014 08:52:36 -0700, Mike Waychison wrote:
> On Wed, May 14, 2014 at 2:23 AM, Jean Delvare <jdelvare@suse.de> wrote:
> > Sorry for joining the party a little late but I am just discovering the
> > dmi-sysfs kernel module. I have to admit that I am very curious about
> > why it was needed. What does it let you achieve that you couldn't
> > already do with dmidecode [1]?
> 
> The downside to using dmidecode is that (at least at the time), it
> involved requiring giving access to /dev/mem to the binary so that it
> could grub around in raw memory looking for the records.

This is still the case indeed.

> dmi-sysfs
> provides an alternative that allows for kernel-parsed entries to be
> exposed to userland without having to expose /dev/mem and raw IO which
> is insecure.

Thanks for the explanation. But if access to /dev/mem was your only
concern, your solution seems somewhat overkill. You could have just
exposed the raw SMBIOS entry point and DMI table through sysfs, pretty
much like ACPI does, and leave the rest to dmidecode (or libsmbios.)
That would have avoided reimplementing part of dmidecode and creating
yet another interface to DMI data.

I'm not maintaining dmi-sysfs, I'm not even using it so far, so I don't
really care, but to be honest I am quite surprised that it was accepted
into the kernel.

-- 
Jean Delvare
SUSE L3 Support
