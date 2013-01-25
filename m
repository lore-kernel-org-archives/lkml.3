Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3AZAAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:00:13 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47853 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3AZAAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:00:09 -0500
Date: Fri, 25 Jan 2013 18:59:53 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: acking@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
Message-ID: <20130125235953.GA4833@hmsreliant.think-freely.org>
References: <1359135470-30677-1-git-send-email-acking@vmware.com>
 <1359135470-30677-2-git-send-email-acking@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359135470-30677-2-git-send-email-acking@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 09:37:50AM -0800, acking@vmware.com wrote:
> From: Andy King <acking@vmware.com>
> 
> VM Sockets allows communication between virtual machines and the hypervisor.
> User level applications both in a virtual machine and on the host can use the
> VM Sockets API, which facilitates fast and efficient communication between
> guest virtual machines and their host.  A socket address family, designed to be
> compatible with UDP and TCP at the interface level, is provided.
> 
> Today, VM Sockets is used by various VMware Tools components inside the guest
> for zero-config, network-less access to VMware host services.  In addition to
> this, VMware's users are using VM Sockets for various applications, where
> network access of the virtual machine is restricted or non-existent.  Examples
> of this are VMs communicating with device proxies for proprietary hardware
> running as host applications and automated testing of applications running
> within virtual machines.
> 
> The VMware VM Sockets are similar to other socket types, like Berkeley UNIX
> socket interface.  The VM Sockets module supports both connection-oriented
> stream sockets like TCP, and connectionless datagram sockets like UDP. The VM
> Sockets protocol family is defined as "AF_VSOCK" and the socket operations
> split for SOCK_DGRAM and SOCK_STREAM.
> 
> For additional information about the use of VM Sockets, please refer to the VM
> Sockets Programming Guide available at:
> 
> https://www.vmware.com/support/developer/vmci-sdk/
> 
> Signed-off-by: George Zhang <georgezhang@vmware.com>
> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
> Signed-off-by: Andy king <acking@vmware.com>
> index 0000000..95e2568
> --- /dev/null
> +++ b/net/vmw_vsock/Kconfig
> @@ -0,0 +1,14 @@
> +#
> +# Vsock protocol
> +#
> +
> +config VMWARE_VSOCK
> +	tristate "Virtual Socket protocol"
> +	depends on VMWARE_VMCI
What is CONFIG_VMWARE_VMCI?  I don't find that in any Kconfig in the tree?

I''m still looking over the rest, but I get build issues if I just remove the
dependency.

Neil

