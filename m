Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936549Ab3DRUGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 16:06:17 -0400
Received: from 8bytes.org ([85.214.48.195]:49449 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab3DRUGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 16:06:16 -0400
Date: Thu, 18 Apr 2013 22:06:13 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
Message-ID: <20130418200613.GB17148@8bytes.org>
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130418160220.GA4153@8bytes.org>
 <51701B9F.10003@amd.com>
 <20130418162856.GA13891@8bytes.org>
 <5170268E.8080706@amd.com>
 <20130418183538.GA17148@8bytes.org>
 <517041EA.70407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517041EA.70407@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Apr 18 22:06:13 2013
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5170523523678713611422
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 01:56:42PM -0500, Suthikulpanit, Suravee wrote:
> On 4/18/2013 1:35 PM, Joerg Roedel wrote:

> According to the "kernel/irq/handle.c:irq_wake_thread()", I thought
> that for the threaded IRQ, if the system getting a new interrupt
> from the device while the thread is running, it will just return and
> do nothing.

Yes, but the irq-thread function itself executes the handler function
repeatedly until the IRQTF_RUNTHREAD bit is cleared. And every new
interrupt will set this bit again. So when there is a new interrupt
while our handler function runs the handler will be called again by the
irq-thread.


	Joerg


