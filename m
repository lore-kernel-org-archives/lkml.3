Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3IWTKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:10:33 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:56908 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752635Ab3IWTKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:10:32 -0400
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 15:10:32 EDT
X-TM-IMSS-Message-ID: <2d96b76b000242f0@nsa.gov>
Message-ID: <52408E5D.4020904@tycho.nsa.gov>
Date: Mon, 23 Sep 2013 14:54:21 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to sysfs
 into tpm-sysfs.c
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com>
In-Reply-To: <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 02:14 PM, Jason Gunthorpe wrote:
> CLASS-sysfs.c is a common idiom for linux subsystems.
>
> This pulls all the sysfs attribute functions and related code
> into tpm-sysfs.c. To support this change some constants are moved
> from tpm.c to tpm.h and __tpm_pcr_read is made non-static and is
> called tpm_pcr_read_dev.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
[...]
> diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
> index 12a4ab2..7892557 100644
> --- a/drivers/char/tpm/xen-tpmfront.c
> +++ b/drivers/char/tpm/xen-tpmfront.c
[...]
> -static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
> -static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
> -static DEVICE_ATTR(locality, S_IRUGO | S_IWUSR, tpm_show_locality,
> -		tpm_store_locality);

This patch drops the "locality" sysfs attribute from xen-tpmfront. Since
that attribute is currently only implemented for the xen TPM driver, it
is best to leave it there for now (and its show/store functions could
also be made static, an oversight I just noticed now). If this attribute
is later made available on other TPM drivers, it may need to contain
device-specific logic, but such an implementation is well outside the
scope of this series.

-- 
Daniel De Graaf
National Security Agency
