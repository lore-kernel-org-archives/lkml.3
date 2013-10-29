Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3J2Lpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:45:44 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36532 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3J2Lpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:45:43 -0400
Date: Tue, 29 Oct 2013 07:45:34 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, yinghai@kernel.org, Knut_Petersen@t-online.de,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 3/3] msi: always unregister ->msi_kset within
 free_msi_irqs()
Message-ID: <20131029114534.GD24477@neilslaptop.think-freely.org>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
 <1383042632-7102-4-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383042632-7102-4-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:30:32AM +0100, Veaceslav Falico wrote:
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

