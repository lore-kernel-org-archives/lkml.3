Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3BEQlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:41:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab3BEQlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:41:36 -0500
Message-ID: <51113637.7070209@redhat.com>
Date: Tue, 05 Feb 2013 17:41:27 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, davem@davemloft.net
Subject: Re: [PATCH 0/1] VM Sockets for Linux upstreaming
References: <1360020362-25561-1-git-send-email-acking@vmware.com>
In-Reply-To: <1360020362-25561-1-git-send-email-acking@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> Unlike previous submissions, where the new socket family was entirely reliant
> on VMware's VMCI PCI device (and thus VMware's hypervisor), VM Sockets is now
> *completely* separated out into two parts, each in its own module:

Some separation still needs to be done:

  CC [M]  net/vmw_vsock/af_vsock.o
In file included from
/home/kraxel/projects/linux/net/vmw_vsock/af_vsock.c:102:0:
/home/kraxel/projects/linux/net/vmw_vsock/af_vsock.h:21:33: fatal error:
linux/vmw_vmci_defs.h: No such file or directory
compilation terminated.
make[4]: *** [net/vmw_vsock/af_vsock.o] Error 1

[ with  vmci series from jan 9th applied on top it builds ]

Module deps are a bit bogous too:

vmw_vsock_vmci_transport    26162  0
vsock                  34481  1 vmw_vsock_vmci_transport
vmw_vmci               61602  2 vsock,vmw_vsock_vmci_transport

Only vmw_vsock_vmci_transport should have a vmw_vmci dependency, not
vsock ...

Nevertheless this should be good enough to start hacking up a virtio
prototype.

cheers,
  Gerd
