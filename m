Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3FHLMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 07:12:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:25433 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3FHLMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 07:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,827,1363158000"; 
   d="scan'208";a="252312777"
Message-ID: <1370690146.2938.64.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] x86/PCI: setup data may be in highmem
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Matt Fleming <matt@console-pimps.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Date: Sat, 08 Jun 2013 14:15:46 +0300
In-Reply-To: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
References: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 10:43 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> pcibios_add_device() assumes that the physical addresses stored in
> setup_data are accessible via the direct kernel mapping, and that
> calling phys_to_virt() is valid. This isn't guaranteed to be true on x86
> where the direct mapping range is much smaller than on x86-64.
> 
> Calling phys_to_virt() on a highmem address results in the following,

Fixes paging request oops for me as well, thanks! Would you please add a
-stable tag to this patch?

-- 
Best Regards,
Artem Bityutskiy

