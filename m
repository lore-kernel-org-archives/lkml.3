Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3L0T2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:28:17 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:34178 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab3L0T2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:28:16 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 14:28:16 EST
Message-ID: <52BDD382.7070505@msgid.tls.msk.ru>
Date: Fri, 27 Dec 2013 23:22:42 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: 3.10.25 kernel behaves unstable as a qemu/kvm guest
X-Enigmail-Version: 1.5.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This is just an initial/preliminary heads-up, maybe mis-directed, about
a possible issue.

I upgraded 2 machines today to 3.10.25, and both shows some.. strangeness
within linux guests, which are also running 3.10.25.  Revering to 3.10.24
in guests (compiled by the same compiler with the same options) or
using older qemu/kvm (running with 1.7 now) fixes it.

All guests are using virtio-net and virtio-blk.

On one machine (prod), one guest (also prod) loads okay, but the networking
is not functioning: no packets are received by the guest.  I weren't able
to debug this further at this time, so reverted back to an older qemu/kvm
(1.1).

On another machine (my home workstation where I can experiment), the same
combination (3.10.25 on host & guest and qemu 1.7) shows rather unstable
behavour: about every 1/2 boot it stalls somewhere at the initial boot,
either after initializing PNP, or initializing networking, or sometimes
after initializing virtio, and the rest 1/2 it boots okay.

When it stalls, it consumes no CPU, qemu process is responsive, the guest
just does nothing.  Like this:

 ...
 NET: Registering protocol family 2
 TCP: established hash table entries: 8192 (order: 5, 131072 bytes)
 TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
 TCP: Hash tables configured (established 8192 bind 8192)
 TCP: reno registered
 [at this point it hanged]

(after this it normally registers UDP hash tables and other net stuff)

I'm not sure yet what's going on.  I understand that there are no guest-related
changes in 3.10.25 (compared with .24), so there should be something else.
The fact that it stalls randomly suggests there's some uninitialized value
somewhere.

I'll try to debug it further.  Just a heads-up for now.

Thanks,

/mjt
