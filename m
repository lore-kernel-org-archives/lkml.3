Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3LPJ2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:28:23 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:45512 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3LPJ2V convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 16 Dec 2013 04:28:21 -0500
Message-Id: <52AED5BF020000780010D869@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 16 Dec 2013 09:28:15 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <gordan@bobich.net>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH 4/5] xen/pciback: Move the FLR code
 to a function.
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
 <1386950978-8628-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386950978-8628-5-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.12.13 at 17:09, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> +void pcistub_reset_pci_dev(struct pci_dev *dev)
> +{
> +	/* This is OK - we are running from workqueue context
> +	 * and want to inhibit the user from fiddling with 'reset'
> +	 */
> +
> +	dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
> +
> +	pci_reset_function(dev);
> +	pci_restore_state(dev);
> +
> +	/* This disables the device. */
> +	xen_pcibk_reset_device(dev);
> +
> +	/* And cleanup up our emulated fields. */
> +	xen_pcibk_config_reset_dev(dev);
> +}

Ah, here it comes. Improperly split series then...

Jan

