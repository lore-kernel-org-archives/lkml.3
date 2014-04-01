Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaDAKsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:48:32 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36889 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAKsa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 1 Apr 2014 06:48:30 -0400
Message-Id: <533AB59A020000780000409F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Tue, 01 Apr 2014 11:48:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daeseok Youn" <daeseok.youn@gmail.com>, <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xen: fix memory leak in
 __xen_pcibk_add_pci_dev()
References: <2172979.BN2CJo57Rq@daeseok-laptop.cloud.net>
In-Reply-To: <2172979.BN2CJo57Rq@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.04.14 at 12:15, <daeseok.youn@gmail.com> wrote:

> It need to free dev_entry when it failed to assign to a new
> slot on the virtual PCI bus.
> 
> smatch says:
>  drivers/xen/xen-pciback/vpci.c:142 __xen_pcibk_add_pci_dev() warn:
> possible memory leak of 'dev_entry'
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

As before
Reviewed-by: Jan Beulich <jbeulich@suse.com>

> ---
> v2: The kfree() invocation is moved outside the locked region.
> 
>  drivers/xen/xen-pciback/vpci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpci.c
> index 3165ce3..51afff9 100644
> --- a/drivers/xen/xen-pciback/vpci.c
> +++ b/drivers/xen/xen-pciback/vpci.c
> @@ -137,6 +137,8 @@ unlock:
>  	/* Publish this device. */
>  	if (!err)
>  		err = publish_cb(pdev, 0, 0, PCI_DEVFN(slot, func), devid);
> +	else
> +		kfree(dev_entry);
>  
>  out:
>  	return err;
> -- 
> 1.7.4.4



