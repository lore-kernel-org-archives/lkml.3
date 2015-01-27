Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbbA0Lf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:35:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50589 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbbA0LfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:35:23 -0500
Date: Tue, 27 Jan 2015 11:35:20 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org,
        dmidecode-devel@nongnu.org, grant.likely@linaro.org,
        leif.lindholm@linaro.org, matt.fleming@intel.com
Subject: Re: [Patch v2 0/2] firmware: dmi-sysfs: add SMBIOS entry point area
 raw attribute
Message-ID: <20150127113520.GG3320@codeblueprint.co.uk>
References: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan, at 03:28:36PM, Ivan Khoronzhuk wrote:
> Some utils, like dmidecode and smbios, needs to access SMBIOS entry
> table area in order to get information like SMBIOS version, size, etc.
> Currently it's done via /dev/mem. But for situation when /dev/mem
> usage is disabled, the utils have to use dmi sysfs instead, which
> doesn't represent SMBIOS entry. So this patch series adds SMBIOS
> area to dmi sysfs in order to allow utils in question to work
> correctly with dmi sysfs.
> 
> v1: https://lkml.org/lkml/2015/1/23/643
> 
> v2..v1:
>   firmware: dmi_scan: add symbol to get SMBIOS entry area
> 	- used additional static var to hold SMBIOS raw table size
> 	- changed format of get_smbios_entry_area symbol
> 	  returned pointer on const smbios table
> 
>   firmware: dmi-sysfs: add SMBIOS entry point area attribute
> 	- adopted to updated get_smbios_entry_area symbol
>   	- removed redundant array to save smbios table
> 
> Ivan Khoronzhuk (2):
>   firmware: dmi_scan: add symbol to get SMBIOS entry area
>   firmware: dmi-sysfs: add SMBIOS entry point area attribute
> 
>  drivers/firmware/dmi-sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/firmware/dmi_scan.c  | 26 ++++++++++++++++++++++++++
>  include/linux/dmi.h          |  3 +++
>  3 files changed, 71 insertions(+)

Unless anyone beats me to it, I'll pickup these two patches.

-- 
Matt Fleming, Intel Open Source Technology Center
