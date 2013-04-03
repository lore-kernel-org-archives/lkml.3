Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599Ab3DCCxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:53:47 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59132 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3DCCxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:53:46 -0400
Date: Tue, 2 Apr 2013 22:53:43 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, LKML <linux-kernel@vger.kernel.org>
Message-ID: <28255253.1085258.1364957623947.JavaMail.root@redhat.com>
In-Reply-To: <19926.1364924330@warthog.procyon.org.uk>
References: <1484037905.443048.1364884090669.JavaMail.root@redhat.com> <19926.1364924330@warthog.procyon.org.uk>
Subject: Re: NULL pointer at kset_find_obj
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: NULL pointer at kset_find_obj
Thread-Index: P7mI4ryFJCbjQHdcPfArcs3s6VBZ3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "David Howells" <dhowells@redhat.com>
> To: "CAI Qian" <caiqian@redhat.com>, rusty@rustcorp.com.au
> Cc: dhowells@redhat.com, "LKML" <linux-kernel@vger.kernel.org>
> Sent: Wednesday, April 3, 2013 1:38:50 AM
> Subject: Re: NULL pointer at kset_find_obj
> 
> CAI Qian <caiqian@redhat.com> wrote:
> 
> > Just booted the latest mainline,
> > 
> > [   35.217698] Request for unknown module key 'Magrathea: Glacier signing
> > key: 8b7774b08bc4ee9637073434c10f0823f6fbe523' err -11
> 
> Can you check back earlier in the dmesg to see whether the kernel tried to
> load the key?  -11 is presumably -EAGAIN - in which case no such key was
> found
> (rather than there being a cached lookup failure which is what -ENOKEY would
> indicate).  It is possible that you encountered the key-not-yet-valid problem
> due to your h/w clock showing a value prior to the start date on the key.
Hmm, unsure about how to check it, but here is the full log prior the panic,
http://people.redhat.com/qcai/stable/log.key

CAI Qian
>  
> > [   35.218511] BUG: unable to handle kernel paging request at
> > ffffffffa03093f0
> > [   35.218521] IP: [<ffffffff81304710>] kset_find_obj+0x30/0x80
> > ...
> > [   35.218575] Call Trace:
> > [   35.218583]  [<ffffffff810c827d>] load_module+0xb0d/0x1b00
> > [   35.218587]  [<ffffffff81321880>] ? ddebug_proc_open+0xc0/0xc0
> > [   35.218593]  [<ffffffff81628cd8>] ? page_fault+0x28/0x30
> > [   35.218596]  [<ffffffff810c9347>] sys_init_module+0xd7/0x120
> > [   35.218601]  [<ffffffff81630d59>] system_call_fastpath+0x16/0x1b
> 
> I think this bit should be waved in front of Rusty.  It looks like it might
> be
> a bug in error handling code.
> 
> David
> 
