Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3LBSBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:01:54 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33362 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3LBSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:01:52 -0500
Date: Mon, 2 Dec 2013 10:01:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Joe Perches <joe@perches.com>
Cc: Jonas Bonn <jonas@southpole.se>, Jingoo Han <jg1.han@samsung.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andy Whitcroft'" <apw@canonical.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] pci/checkpatch: Deprecate DEFINE_PCI_DEVICE_TABLE
Message-ID: <20131202180147.GB31606@roeck-us.net>
References: <1385617213.12210.5.camel@joe-AO722>
 <20131128055328.GA565@kroah.com>
 <1385619863.12210.14.camel@joe-AO722>
 <529C026E.2000302@roeck-us.net>
 <000f01ceef11$a14acf00$e3e06d00$%han@samsung.com>
 <529C04C7.9050506@roeck-us.net>
 <001001ceef13$7fa3ee70$7eebcb50$%han@samsung.com>
 <1385963295.2680.2.camel@joe-AO722>
 <529C6495.3020305@southpole.se>
 <1386006217.2680.13.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386006217.2680.13.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:43:37AM -0800, Joe Perches wrote:
> Prefer use of the direct definition of struct pci_device_id

Add 'const' ?

> instead of indirection via macro DEFINE_PCI_DEVICE_TABLE.
> 
> Update the PCI documentation to deprecate DEFINE_PCI_DEVICE_TABLE.
> Update checkpatch adding --fix option.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  Documentation/PCI/pci.txt |  6 ++++--
>  include/linux/pci.h       |  3 +--
>  scripts/checkpatch.pl     | 11 +++++++----
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
> index 6f45856..9518006 100644
> --- a/Documentation/PCI/pci.txt
> +++ b/Documentation/PCI/pci.txt
> @@ -123,8 +123,10 @@ initialization with a pointer to a structure describing the driver
>  
>  
>  The ID table is an array of struct pci_device_id entries ending with an
> -all-zero entry; use of the macro DEFINE_PCI_DEVICE_TABLE is the preferred
> -method of declaring the table.  Each entry consists of:
> +all-zero entry.  Definitions with static const are generally preferred.
> +Use of the deprecated macro DEFINE_PCI_DEVICE_TABLE should be avoided.
> +
> +Each entry consists of:
>  
>  	vendor,device	Vendor and device ID to match (or PCI_ANY_ID)
>  
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 1084a15..88674b0 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -634,8 +634,7 @@ struct pci_driver {
>   * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
>   * @_table: device table name
>   *
> - * This macro is used to create a struct pci_device_id array (a device table)
> - * in a generic manner.
> + * This macro is deprecated and should not be used in new code.
>   */
>  #define DEFINE_PCI_DEVICE_TABLE(_table) \
>  	const struct pci_device_id _table[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 38be5d5..6f883f0 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2643,10 +2643,13 @@ sub process {
>  			}
>  		}
>  
> -# check for declarations of struct pci_device_id
> -		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
> -			WARN("DEFINE_PCI_DEVICE_TABLE",
> -			     "Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
> +# check for uses of DEFINE_PCI_DEVICE_TABLE
> +		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
> +			if (WARN("DEFINE_PCI_DEVICE_TABLE",
> +				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&

Add 'const' ?

Guenter
