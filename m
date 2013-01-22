Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3AVPQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:16:38 -0500
Received: from 8bytes.org ([85.214.48.195]:44179 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3AVPQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:16:36 -0500
Date: Tue, 22 Jan 2013 16:16:32 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, suravee.suthikulpanit@amd.com,
        Jacob Shin <jacob.shin@amd.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130122151632.GS25591@8bytes.org>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
 <50FE9E76.30702@xs4all.nl>
 <50FEA3F2.1070408@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FEA3F2.1070408@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan 22 16:16:34 2013
X-DSPAM-Confidence: 0.9980
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50fead5222975526618350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 09:36:34AM -0500, Boris Ostrovsky wrote:
> 
> 
> On 01/22/2013 09:13 AM, Udo van den Heuvel wrote:
> >Gigabyte demonstrate that using ESX 5i IOMMU works fine. (with pictures
> >attached).
> 
> There are no attachments to your message.
> 
> I am not sure that 5i supports IOMMU (but I may well be wrong).

Virtualization use-cases don't change the page-tables for the IOMMU very
often. So there is less need to flush the IO-TLB and IOMMU command
processing is utilized only from time to time.

In Linux however the page-tables change all the time and there is a much
higher load on the IOMMU command buffer which makes it much more likely
to trigger the hardware problem.


	Joerg


