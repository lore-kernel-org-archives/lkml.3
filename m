Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbbANEeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 23:34:21 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:50022 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbANEeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 23:34:19 -0500
Message-ID: <54B5F1C6.7040307@landley.net>
Date: Tue, 13 Jan 2015 22:34:14 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        initramfs <initramfs@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        "casey.schaufler" <casey.schaufler@intel.com>,
        Paul Moore <pmoore@redhat.com>
Subject: Re: [RFC][PATCH 6/9] gen_initramfs_list.sh: include xattrs
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>	 <1420663980-20842-7-git-send-email-zohar@linux.vnet.ibm.com>	 <CA+5PVA77x2W9LyHMq1jSW3HKqNgFPz-gPVOH0QtEmmMBwzOx_Q@mail.gmail.com>	 <1420729994.6338.52.camel@dhcp-9-2-203-236.watson.ibm.com>	 <54AECA32.6000304@landley.net>	 <1420754931.6338.95.camel@dhcp-9-2-203-236.watson.ibm.com>	 <54B56881.30403@landley.net>	 <1421180416.2119.73.camel@dhcp-9-2-203-236.watson.ibm.com>	 <54B5913C.5050109@landley.net> <1421205803.2119.110.camel@dhcp-9-2-203-236.watson.ibm.com>
In-Reply-To: <1421205803.2119.110.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/13/2015 09:23 PM, Mimi Zohar wrote:
> On Tue, 2015-01-13 at 15:42 -0600, Rob Landley wrote: 
>>> 4 bytes enough?
> 
>> Eh, as long as we're breaking compatibility anyway, we might as well
>> extend the file size. It's gzipped so the extra run of consecutive
>> zeroes isn't really an issue, and if tmpfs is going to support 64 bit
>> file sizes the thing that's populating them should to just to match.
>> (You can already have memory bigger than 4g. Some crazy person is going
>> to put a squashfs in tmpfs and loopback mount it, or have a giant video
>> there, or... Bootloaders being able to cope with this is not my problem. :)
> 
>> Probably having the new fields at the end (and gluing them to the
>> earlier ones) makes more sense than having variable sized fields? I
>> don't have a strong opinion either way.
> 
> The current file data size header field is a 8 character hexidecimal
> string, which is long enough to store 4g (0xFFFFFFFF).

The current header fields are all 32 bits, yes. To get a 64 bit field
we'd have to add a second 32 bit field and add it <<32 to the original
one, or else have the header fields be of varying sizes. That was the
"adding a new one to the end" thing mentioned above.

Then again if we add a new field right before the previous size then the
"treat it as 64 bits vs 2 32 bit ones" is an implementation detail
anyway. And for the moment we can just have it be padding that
compresses away and wait for an actual >4g file.

Unless you think nobody will ever need an archive member >4g in
initramfs, even though servers with ~256g are reasonably common today
already?

Rob
