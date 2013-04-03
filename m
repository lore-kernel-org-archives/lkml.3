Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598Ab3DCGtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:49:46 -0400
Received: from ozlabs.org ([203.10.76.45]:44155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762516Ab3DCGtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:49:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>, CAI Qian <caiqian@redhat.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer at kset_find_obj
In-Reply-To: <19926.1364924330@warthog.procyon.org.uk>
References: <1484037905.443048.1364884090669.JavaMail.root@redhat.com> <19926.1364924330@warthog.procyon.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 03 Apr 2013 16:40:13 +1030
Message-ID: <874nfo5em2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> CAI Qian <caiqian@redhat.com> wrote:
>
>> Just booted the latest mainline,
>> 
>> [   35.217698] Request for unknown module key 'Magrathea: Glacier signing
>> key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11
>
> Can you check back earlier in the dmesg to see whether the kernel tried to
> load the key?  -11 is presumably -EAGAIN - in which case no such key was found
> (rather than there being a cached lookup failure which is what -ENOKEY would
> indicate).  It is possible that you encountered the key-not-yet-valid problem
> due to your h/w clock showing a value prior to the start date on the key.
>  
>> [   35.218511] BUG: unable to handle kernel paging request at ffffffffa03093f0 
>> [   35.218521] IP: [<ffffffff81304710>] kset_find_obj+0x30/0x80 
>> ...
>> [   35.218575] Call Trace: 
>> [   35.218583]  [<ffffffff810c827d>] load_module+0xb0d/0x1b00 
>> [   35.218587]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0 
>> [   35.218593]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30 
>> [   35.218596]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120 
>> [   35.218601]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b 
>
> I think this bit should be waved in front of Rusty.  It looks like it might be
> a bug in error handling code.

It does look like it, but I can't see it.  The module code doesn't see
an error (presumably sig_enforce is false), so we continue processing
the module like normal.

Is the module getting corrupted somehow?  I don't think the signing
infrastructure is doing it...

Puzzled,
Rusty.
