Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab3BGAcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:32:36 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:42825 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab3BGAcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:32:33 -0500
Date: Wed, 6 Feb 2013 16:32:30 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net
Message-ID: <1231523602.1815949.1360197150398.JavaMail.root@vmware.com>
In-Reply-To: <1315741351.2964541.1360083749055.JavaMail.root@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 0/1] VM Sockets for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2681 (ZimbraWebClient - GC24 (Mac)/7.2.0_GA_2681)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

> > linux/vmw_vmci_defs.h: No such file or directory
> > compilation terminated.
> > make[4]: *** [net/vmw_vsock/af_vsock.o] Error 1
> 
> Oops, you're right, it really shouldn't need that header.  Sorry
> about that, let me rip that out.

Fixed.  The VMCI headers are now gone from the core in af_vsock.*
and vsock_addr.*

> > Only vmw_vsock_vmci_transport should have a vmw_vmci dependency,
> > not vsock ...
> 
> Agreed, that's not right, I'll fix that too.

Fixed, lsmod now shows that only the transport has a dependency.

Also, it turns out that we do need a dgram_recv(), since our
transport currently enqueues skbs with VMCI DGRAMs in them, which
need to be converted before copying into the user's buffer.  I've
added that too.

Please see latest patchset (sent a few minutes ago), hope it works
for you this time.

Thanks!
- Andy
