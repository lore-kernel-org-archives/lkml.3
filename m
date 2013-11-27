Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3K0TyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:54:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39426 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3K0TyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:54:07 -0500
Date: Wed, 27 Nov 2013 19:53:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: bhelgaas@google.com, cl91tp@gmail.com, tianyu.lan@intel.com,
        khlebnikov@openvz.org, gnomes@lxorguk.ukuu.org.uk,
        indou.takao@jp.fujitsu.com, jility09@gmail.com, f.otti@gmx.at,
        ebiederm@xmission.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
Message-ID: <20131127195317.GA13028@srcf.ucam.org>
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com>
 <20131127192420.GC11829@srcf.ucam.org>
 <52964C9A.6040305@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52964C9A.6040305@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:48:42PM -0700, Khalid Aziz wrote:

> I debated between pci.h and kexec.h but pci-driver.c does not
> include kexec.h and I didn't want to include a whole new file. Now I
> see another problem with adding that extern declaration to pci.h -
> if CONFIG_KEXEC is not set, build will fail. I should add #ifdef
> CONFIG_KEXEC to the code in pci-driver.c as well. Time for v2.

You're making the behaviour of the pci code conditional on whether we're 
in kexec or not, so I think adding kexec.h is perfectly reasonable.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
