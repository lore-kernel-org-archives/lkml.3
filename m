Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3BERCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:02:45 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:41336 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925Ab3BERCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:02:43 -0500
Date: Tue, 5 Feb 2013 09:02:29 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, davem@davemloft.net
Message-ID: <1315741351.2964541.1360083749055.JavaMail.root@vmware.com>
In-Reply-To: <51113637.7070209@redhat.com>
Subject: Re: [PATCH 0/1] VM Sockets for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2681 (ZimbraWebClient - GC24 (Mac)/7.2.0_GA_2681)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

> Some separation still needs to be done:
> 
>   CC [M]  net/vmw_vsock/af_vsock.o
> In file included from
> /home/kraxel/projects/linux/net/vmw_vsock/af_vsock.c:102:0:
> /home/kraxel/projects/linux/net/vmw_vsock/af_vsock.h:21:33: fatal
> error:
> linux/vmw_vmci_defs.h: No such file or directory
> compilation terminated.
> make[4]: *** [net/vmw_vsock/af_vsock.o] Error 1

Oops, you're right, it really shouldn't need that header.  Sorry
about that, let me rip that out.

> Module deps are a bit bogous too:
> 
> vmw_vsock_vmci_transport    26162  0
> vsock                  34481  1 vmw_vsock_vmci_transport
> vmw_vmci               61602  2 vsock,vmw_vsock_vmci_transport
> 
> Only vmw_vsock_vmci_transport should have a vmw_vmci dependency, not
> vsock ...

Agreed, that's not right, I'll fix that too.

> Nevertheless this should be good enough to start hacking up a virtio
> prototype.

Great!

Thanks!
- Andy
