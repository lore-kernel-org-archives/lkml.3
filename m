Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaFRASt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:18:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356AbaFRASp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:18:45 -0400
Date: Tue, 17 Jun 2014 20:18:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, ganesanr@broadcom.com
Subject: Re: MIPS: Add MSI support for XLP9XX
Message-ID: <20140618001837.GA24753@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org, ganesanr@broadcom.com
References: <20140610013104.DF5A8660F61@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610013104.DF5A8660F61@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 01:31:04AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d66f3f0e10b49df8d0cc0d8eb5bf2ef9863a33cf
 > Commit:     d66f3f0e10b49df8d0cc0d8eb5bf2ef9863a33cf
 > Parent:     1c98398662c9b4e2f03f64344f83dd6cb14e0420
 > Refname:    refs/heads/master
 > Author:     Ganesan Ramalingam <ganesanr@broadcom.com>
 > AuthorDate: Fri May 9 16:35:49 2014 +0530
 > Committer:  Ralf Baechle <ralf@linux-mips.org>
 > CommitDate: Fri May 30 16:51:02 2014 +0200
 > 
 >     MIPS: Add MSI support for XLP9XX

...

 > +		if (cpu_is_xlp9xx()) {
 > +			val = ((node * nlm_threads_per_node()) << 7 |
 > +				PIC_PCIE_MSIX_IRQ(link) << 1 | 0 << 0);

Should this be..

			val = ((node * nlm_threads_per_node()) << 7 |
				PIC_PCIE_MSIX_IRQ(link) << 1);
			val &= ~(1 << 0);

perhaps ? because shifting a zero is a nop, as is ORing it.

	Dave
