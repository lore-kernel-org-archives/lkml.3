Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935688Ab3BOKcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935617Ab3BOKcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:32:45 -0500
Message-ID: <511E0EC4.9030405@redhat.com>
Date: Fri, 15 Feb 2013 11:32:36 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com>
In-Reply-To: <1360196636-9357-2-git-send-email-acking@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/13 01:23, Andy King wrote:
> +/* Use this as the destination CID in an address when referring to the
> + * hypervisor.  VMCI relies on it being 0, but this would be useful for other
> + * transports too.
> + */
> +
> +#define VMADDR_CID_HYPERVISOR 0
> +
> +/* This CID is specific to VMCI and can be considered reserved (even VMCI
> + * doesn't use it anymore, it's a legacy value from an older release).
> + */
> +
> +#define VMADDR_CID_RESERVED 1
> +
> +/* Use this as the destination CID in an address when referring to the host
> + * (any process other than the hypervisor).  VMCI relies on it being 2, but
> + * this would be useful for other transports too.
> + */
> +
> +#define VMADDR_CID_HOST 2

CIDs larger than 2 will address other VMs on the same host, with the
hypervisor forwarding the data from one guest to the other and back?

How does VMADDR_CID_HOST work?  Given the age of the vsock transport
layer I don't think you have a vsock_transport_host.ko module ...

Is there some registry for the port numbers?

cheers,
  Gerd
