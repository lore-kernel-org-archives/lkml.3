Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3KLIko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:40:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3KLIke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:40:34 -0500
Message-ID: <5281E97D.6090806@suse.cz>
Date: Tue, 12 Nov 2013 09:40:29 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH 1/2] PCI: Do not use PCI ID macros in quirk names
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.2013 14:40, Michal Marek wrote:
> Pasting the verbatim PCI_(VENDOR|DEVICE)_* macros in the __pci_fixup_*
> symbol names results in insanely long names such as
> 
> __pci_fixup_resumePCI_VENDOR_ID_SERVERWORKSPCI_DEVICE_ID_SERVERWORKS_HT1000SBquirk_disable_broadcom_boot_interrupt
> 
> When LTO adds its numeric suffix to such symbol, it overflows the
> namebuf[KSYM_NAME_LEN] array. Use the line number instead to create

"... the namebuf[KSYM_NAME_LEN] array in kernel/kallsyms.c."

That way, the changelog is hopefully more clear.

Michal
