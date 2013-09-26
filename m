Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3IZPSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:18:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33613 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3IZPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:18:06 -0400
Date: Thu, 26 Sep 2013 11:17:49 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] msi: always unregister ->msi_kset within
 free_msi_irqs()
Message-ID: <20130926151749.GE12301@hmsreliant.think-freely.org>
References: <1380204675-18238-1-git-send-email-vfalico@redhat.com>
 <1380204675-18238-2-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380204675-18238-2-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:11:14PM +0200, Veaceslav Falico wrote:
> Currently we create and populate ->msi_kset while allocating irqs in
> populate_msi_sysfs(), however if it fails and/or we want to free the
> entries - we don't always remove it, and we might have problems if we've
> failed to allocate irqs and try it again.
> 
> To fix that, move the unregister part to free_msi_irqs() and remove already
> existing ones. Also, verify if it was actually created - we don't always
> call free_msi_irqs() after populate_msi_sysfs().
> 
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: linux-pci@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
