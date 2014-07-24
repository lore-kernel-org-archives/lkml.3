Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbaGXNzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:55:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42833 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827AbaGXNz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:55:29 -0400
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140724122223.GA31798@sucs.org>
Date: Thu, 24 Jul 2014 09:54:24 -0400
In-Reply-To: <20140724122223.GA31798@sucs.org> (Sitsofe Wheeler's message of
	"Thu, 24 Jul 2014 13:22:23 +0100")
Message-ID: <yq1iommkgkv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> Fix incorrectly named variable.  Some block devices (such as
Sitsofe> Hyper-V passthrough SSDs) support logical block provisioning
Sitsofe> (e.g. via UNMAP) but don't set lbpme thus disabling discard. 

The fix for an SSD that is known to support LBP but which does not claim
support for it is to use:

    echo unmap > /sys/class/scsi_disk/foo/provisioning_mode

I'm very much against short-circuiting the LBP logic in a passthrough
driver because then we might end up in the exact situation we were
trying to avoid with this patch series. Namely sending down commands
unsupported by the target device.

This kind of thing really needs to be a sysadmin decision and can be
handled with a udev rule.

-- 
Martin K. Petersen	Oracle Linux Engineering
