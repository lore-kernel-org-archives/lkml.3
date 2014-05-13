Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaEMKgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:36:00 -0400
Received: from 8bytes.org ([85.214.48.195]:43147 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbaEMKf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:35:58 -0400
Date: Tue, 13 May 2014 12:35:56 +0200
From: "joro@8bytes.org" <joro@8bytes.org>
To: "Su, Friendy" <Friendy.Su@sony.com.cn>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] iommu/amd: fix enabling exclusion range for an
 exact device
Message-ID: <20140513103556.GB23770@8bytes.org>
References: <053191AD6E9023439BF3970DE87005185086D31DA3@APSHAXMS02.ap.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <053191AD6E9023439BF3970DE87005185086D31DA3@APSHAXMS02.ap.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue May 13 12:35:56 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5371f58c20865870821153
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 01:54:52PM +0800, Su, Friendy wrote:
> 
> From: Su Friendy <friendy.su@sony.com.cn>
> 
> set_device_exclusion_range(u16 devid, struct ivmd_header *m) enables
> exclusion range for ONE device. IOMMU does not translate the access
> to the exclusion range from the device.
> 
> The device is specified by input argument 'devid'. But 'devid' is not
> passed to the actual set function set_dev_entry_bit(), instead
> 'm->devid' is passed. 'm->devid' does not specify the exact device
> which needs enable the exclusion range. 'm->devid' represents DeviceID
> field of IVMD, which has different meaning depends on IVMD type.
> 
> The caller init_exclusion_range() sets 'devid' for ONE device. When
> m->type is equal to ACPI_IVMD_TYPE_ALL or ACPI_IVMD_TYPE_RANGE,
> 'm->devid' is not equal to 'devid'.
> 
> This patch fixes 'm->devid' to 'devid'.
> 
> Signed-off-by: Su Friendy <friendy.su@sony.com.cn>
> Signed-off-by: Tamori Masahiro <Masahiro.Tamori@jp.sony.com>

Applied, thanks.


