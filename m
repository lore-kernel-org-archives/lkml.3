Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672AbaD3PA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:00:56 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:48187 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048AbaD3PAz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 30 Apr 2014 11:00:55 -0400
X-Greylist: delayed 1211 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 11:00:54 EDT
Message-Id: <53612787020000780000DDA0@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 30 Apr 2014 15:40:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 6/6] xen/pciback: Don't call
 xen_pcibk_config_init_dev when device de-assigned.
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
 <1398866051-32714-7-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1398866051-32714-7-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.04.14 at 15:54, <konrad.wilk@oracle.com> wrote:
> When the device is de-assigned from a guest (but still owned
> by xen-pciback) we would needlessly free all of its dynamic
> entries.

I wonder whether that isn't intentional - dynamic fields are only
being used for what comes through the "quirks" attribute.

> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -288,8 +288,6 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  
>  	/* And cleanup up our emulated fields. */
>  	xen_pcibk_config_reset_dev(dev);
> -	xen_pcibk_config_free_dyn_fields(dev);
> -

Irrespective of the above, patch title and contents are out of sync.

Jan

