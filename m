Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161241AbaDJWhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:37:45 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:51115 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161061AbaDJWhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:37:42 -0400
Message-ID: <1397169459.2608.61.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] hpsa: fix uninitialized trans_support in
 hpsa_put_ctlr_into_performant_mode()
From: Davidlohr Bueso <davidlohr@hp.com>
To: scameron@beardog.cce.hp.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Date: Thu, 10 Apr 2014 15:37:39 -0700
In-Reply-To: <20140410221704.GA22465@beardog.cce.hp.com>
References: <20140410221704.GA22465@beardog.cce.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 17:17 -0500, scameron@beardog.cce.hp.com wrote:
> Without this, you'll see a null pointer dereference in
> hpsa_enter_performant_mode().

So I'm not surprised that this patch doesn't solve the problem I am
seeing with DMAR and the hpsa driver hard lockup.

In any case it should address Baoquan's original report, so it confirms
that it is in fact two different sets of issues.

