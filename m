Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaHKRvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:51:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:32409 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbaHKRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:51:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="370953348"
Date: Mon, 11 Aug 2014 10:51:36 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: platform: intel-mid: sfi.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Message-ID: <20140811175136.GB26362@psi-dev26.jf.intel.com>
References: <1406413618-7691-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140811165739.GA26362@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811165739.GA26362@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 09:57:39AM -0700, David Cohen wrote:
> Hi Rickard,
> 
> Sorry for the late reply. Just came back from vacation :)
> 
> On Sun, Jul 27, 2014 at 12:26:58AM +0200, Rickard Strandqvist wrote:
> > If you are going to use memset before strncpy you must copy sizeof -1
> 
> I agree it is way safer to not reply on firmware to have the null
> terminator in place. But can you provide a better patch description? :)
> It would be better if it is not a line addressed directly to the author.
> Please refer the null terminator concern too.

Guess my brain is not fully back from vacation after all :)
The patch subject mentions the null terminator.

Patch looks fine.

> 
> Br, David
> 
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: David Cohen <david.a.cohen@linux.intel.com>

> > ---
> >  arch/x86/platform/intel-mid/sfi.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
> > index 994c40b..97e79c9 100644
> > --- a/arch/x86/platform/intel-mid/sfi.c
> > +++ b/arch/x86/platform/intel-mid/sfi.c
> > @@ -359,7 +359,7 @@ static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
> >  	void *pdata = NULL;
> >  
> >  	memset(&spi_info, 0, sizeof(spi_info));
> > -	strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
> > +	strncpy(spi_info.modalias, pentry->name, sizeof(spi_info.modalias) - 1);
> >  	spi_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
> >  	spi_info.bus_num = pentry->host_num;
> >  	spi_info.chip_select = pentry->addr;
> > @@ -389,7 +389,7 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
> >  	void *pdata = NULL;
> >  
> >  	memset(&i2c_info, 0, sizeof(i2c_info));
> > -	strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
> > +	strncpy(i2c_info.type, pentry->name, sizeof(i2c_info.type) - 1);
> >  	i2c_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
> >  	i2c_info.addr = pentry->addr;
> >  	pr_debug("I2C bus = %d, name = %16.16s, irq = 0x%2x, addr = 0x%x\n",
> > -- 
> > 1.7.10.4
> > 
